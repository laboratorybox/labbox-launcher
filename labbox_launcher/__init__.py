from ._shellscript import ShellScript

def _update_uid_dir():
    import os
    thisdir = os.path.dirname(os.path.realpath(__file__))
    return f'{thisdir}/docker/updateUID'