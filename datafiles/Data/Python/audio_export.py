import subprocess, platform
from typing import Dict, Sequence, Union


def patch_arguments(function, **patched_kwargs):
    def decorate_name(*args, **kwargs):
        kwargs.update(patched_kwargs)
        return function(*args, **kwargs)

    return decorate_name


def convert_to_int(kwargs: Dict[str, Union[float, int]], fields: Sequence[str]):
    for field in fields:
        kwargs[field] = int(kwargs[field])
    return kwargs


def main(*args, **kwargs):

    # Monkey-patch to avoid ffmpeg/ffprobe calls opening console window
    if (platform.system() == "Windows"):
        subprocess.Popen = patch_arguments(
            subprocess.Popen, creationflags=subprocess.CREATE_NO_WINDOW
        )

    # Convert float arguments to int
    kwargs = convert_to_int(kwargs, ["sample_rate", "channels"])

    import nbswave

    nbswave.render_audio(*args, **kwargs)


if __name__ == "__main__":
    main()
