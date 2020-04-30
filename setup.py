import setuptools

pkg_name = "labbox-launcher"

setuptools.setup(
    name=pkg_name,
    version="0.1.0",
    author="Jeremy Magland",
    author_email="jmagland@flatironinstitute.org",
    description="Launch a labbox container",
    packages=setuptools.find_packages(),
    scripts=[
        "bin/labbox-launcher"
    ],
    install_requires=[
    ],
    classifiers=(
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
    )
)
