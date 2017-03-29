# CMOS-Sensor-Noise
**Characterization of Spatiotemporal Fluctuation in a CMOS Sensor**

**AUTHORS:** Peyvandi, S.<sup>1</sup>, Ekroll, V.<sup>2</sup>, and Gilchrist, A.<sup>1</sup>

1- Department of Psychology, Rutgers, The State University of New Jersey, Newark, New Jersey 07102, USA <br>
2- Laboratory of Experimental Psychology, University of Leuven (KU Leuven), Belgium

## Background
The actual number of photons absorbed by a sensor pixel varies with Poisson fluctuation. When an array of pixels is exposed to light energy, this photon fluctuation introduces a spatial variation in the output signals by individual pixels and a temporal variation in the number of pixels at a given digital count. We propose a model to characterize such spatiotemporal variations in a CMOS sensor exposed repeatedly to a uniformly illuminated color checker. 

## Introduction to the code
This is a repository for the MATLAB codes to estimate the spatial variation in digital counts in a CMOS sensor. The temporal fluctuation of the histogram itself is characterized by temporal variation with repeated exposure.


## Distribution of light energy among pixels of a sensor

### Materials
We captured 180 _*.raw_ images of a small classic xrite colorchecker, uniformly illuminated with a 1000 W quartz-halogen light bulb, using [AR0835HS 1/3.2" 8-megapixel CMOS digital sensor](http://www.onsemi.com/pub_link/Collateral/AR0835HS-D.PDF), manufactured by Aptina-ON Semiconductor. The spectral quantum efficiency functions of the sensor were digitized from the QE plot accessible on-line at the manufacturer [public link](http://www.onsemi.com/pub_link/Collateral/AR0835HS-D.PDF#page=55). The imaging device has a [SUNEX DSL945D-650 lens](http://www.optics-online.com/OOL/DSL/DSL945.PDF) with IR cuttoff filter. 

### Prerequisites
The required functions can be found in the *model_functions_eng_dist* folder. The sensor specifications files are stored in *sensor_data* folder.
To analyze the captured _*.raw_ images, first download [*image_Dataset.tar.gz*](https://github.com/peyvandi/raw-image-files.git) and save to the *image_data* folder. Then, unzip the file to extract 180 _*.raw_ images (*exposure_50ms<#>.raw*). Example of a typical image file:

```
exposure_50ms0008.raw  (50ms is the exposure duration, 0008-th image)
```

### Demo
Run the *demo_1_histogram_estimation.m* in the *Code_File_2* folder. In this demo, the variable *no_of_image_analyzed* takes the total number of images for the analysis. You may choose an integer upto 180, which is the total number of images captured by a CMOS sensor, [*image_Dataset.tar.gz*](https://github.com/peyvandi/raw-image-files.git). The function *img_RAW_read_bayer()* reads **.raw* files from *image_data* folder. The variable *select_patch* takes an integer between 1 to 24, referring to patches of the color checker.

```
no_of_image_analyzed = 10; % a total of 10 images will be analyzed
select_patch = 19; % The white patch is selected
```

## License

This project is released under the terms of the [MIT open-source license](https://github.com/peyvandi/light-energy-distribution-among-cells/blob/master/LICENSE).

## Acknowledgment

* ON Semiconductor for providing the imaging device,
* Aptina Imaging, Co. for providing [DevWareX](https://aptina.atlassian.net/wiki/display/DEVS/Software+Downloads) imaging application, and
* Sunex, Inc. for providing the spectral transmittance of the lens.









