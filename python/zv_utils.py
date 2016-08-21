import os
import glob

def get_img_paths_in_dir(image_dir, suffix='jpg'):
    """
    returns list of paths to images in the given
    directory. 

    Args:
        image_dir (string): path to the directory
            containing the images
        suffix (string): the suffix used to select
            the images (default is `jpg`) 

    Returns:
        [string]: a list of paths

    Note: Hidden system files are ignored
    """
    frames = []
    image_dir = os.path.expanduser(image_dir)
    glob_template = os.path.join(image_dir, '*.{}'.format(suffix))
    paths = glob.glob(glob_template)
    return paths
