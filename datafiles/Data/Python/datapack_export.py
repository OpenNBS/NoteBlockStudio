"""Package generated data-pack files; filesystem errors propagate to GML."""

import filecmp
import os
from pathlib import Path
import shutil
import tempfile
import zipfile


def create_zip(source, destination):
    source = Path(source)
    files = sorted(path for path in source.rglob("*") if path.is_file())
    with zipfile.ZipFile(destination, "x", zipfile.ZIP_DEFLATED) as archive:
        for path in files:
            archive.write(path, path.relative_to(source).as_posix())

    # Validate both the archive and its contents before publishing to the user.
    with zipfile.ZipFile(destination) as archive:
        expected = {path.relative_to(source).as_posix() for path in files}
        if set(archive.namelist()) != expected or archive.testzip() is not None:
            raise OSError("The data-pack archive could not be verified")
        for path in files:
            if archive.read(path.relative_to(source).as_posix()) != path.read_bytes():
                raise OSError("The archived file does not match: " + str(path))
    return True


def copy_folder(source, destination):
    source, destination = Path(source), Path(destination)
    destination.mkdir(parents=True, exist_ok=True)
    for path in sorted(source.rglob("*")):
        target = destination / path.relative_to(source)
        if path.is_dir():
            target.mkdir(parents=True, exist_ok=True)
            continue
        target.parent.mkdir(parents=True, exist_ok=True)
        # A directory-panel grant includes these children. Replace matching
        # files only after a verified copy; preserve all unrelated files.
        descriptor, staged = tempfile.mkstemp(prefix=".nbs-export-", dir=target.parent)
        os.close(descriptor)
        try:
            shutil.copyfile(path, staged)
            if not filecmp.cmp(path, staged, shallow=False):
                raise OSError("The copied file does not match: " + str(path))
            os.replace(staged, target)
        finally:
            if os.path.exists(staged):
                os.unlink(staged)
    return True
