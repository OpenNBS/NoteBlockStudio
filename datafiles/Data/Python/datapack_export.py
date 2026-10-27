"""Package data packs and selected sound files; errors propagate to GML."""

import filecmp
import os
from pathlib import Path, PurePosixPath, PureWindowsPath
import shutil
import tempfile
import zipfile


def clear_staging_directory(source):
    """Remove the private staging tree; leave symlink targets untouched."""
    source = Path(source)
    if source.is_symlink():
        source.unlink()
    elif source.exists():
        shutil.rmtree(source)
    return True


def create_zip(source, destination, filenames=None):
    source = Path(source)
    if filenames is None:
        files = sorted(path for path in source.rglob("*") if path.is_file())
    else:
        # Sound exports provide an explicit list; never walk a shared folder.
        files = set()
        for filename in filenames:
            relative = PurePosixPath(filename.replace("\\", "/"))
            if (
                not relative.parts
                or relative.is_absolute()
                or PureWindowsPath(filename).drive
                or ".." in relative.parts
                or "\0" in filename
            ):
                raise ValueError("Invalid sound archive path: " + filename)
            path = source.joinpath(*relative.parts)
            if not path.is_file():
                raise FileNotFoundError("Sound file is unavailable: " + str(path))
            files.add(path)
        files = sorted(files)
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


def create_sound_zip(source, destination, filenames):
    create_zip(source, destination, filenames)
    with zipfile.ZipFile(destination) as archive:
        return len(archive.infolist())


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
