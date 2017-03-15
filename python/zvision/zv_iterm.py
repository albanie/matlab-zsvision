import os
import subprocess
import matplotlib.pyplot as plt

def zv_dispFig():
    """
    shows a matplotlib plot inline in iTerm by saving 
    it to a temporary file, displaying the file and 
    then cleaning up.

    Note: This function requires the use of an iTerm
    terminal (available from https://www.iterm2.com)
    and requires that the `imgcat` script is on your
    $PATH. It can be useful when running MATLAB on a
    server when you don't have access to a GUI to
    display figures.

    Copyright (C) 2016 Samuel Albanie
    All rights reserved.
    """

    # save figure as png image
    plt.savefig('_tmp.jpeg')
    
    # display in iterm
    subprocess.call(['imgcat','_tmp.jpeg'])
    
    # clear up
    os.remove('_tmp.jpeg');
