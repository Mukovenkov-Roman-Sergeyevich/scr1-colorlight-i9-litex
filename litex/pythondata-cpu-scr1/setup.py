from pythondata_cpu_scr1 import version_str
import setuptools
setuptools.setup(
    name="pythondata-cpu-scr1",
    version=version_str,
    author="Roman Mukovenkov",
    author_email="litex@googlegroups.com",
    description="""\
Python module containing verilog files for scr1 cpu.""",
    long_description_content_type="text/markdown",
    url="https://github.com/Mukovenkov-Roman-Sergeyevich/scr1-colorlight-i9-litex",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Solderpad Hardware Licence Version 2.0",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.5',
    zip_safe=False,
    packages=setuptools.find_packages(),
    package_data={
    	'cpu_scr1': ['cpu_scr1/verilog/**'],
    },
    include_package_data=True,
    project_urls={
        "Bug Tracker": "https://github.com/Mukovenkov-Roman-Sergeyevich/scr1-colorlight-i9-litex/issues",
        "Source Code": "https://github.com/Mukovenkov-Roman-Sergeyevich/scr1-colorlight-i9-litex",
    },
)
