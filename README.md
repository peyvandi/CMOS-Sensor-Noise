# light-energy-distribution-among-cells
**Distribution of Photon Energy among a Population of Interleaved Photoreceptors**

**AUTHORS:** Peyvandi, S.<sup>1</sup>, Ekroll, V.<sup>2</sup>, and Gilchrist, A.<sup>1</sup>

1- Department of Psychology, Rutgers, The State University of New Jersey, Newark, New Jersey 07102, USA <br>
2- Laboratory of Experimental Psychology, University of Leuven (KU Leuven), Belgium

## Background
The actual number of photons absorbed in a photosensitive element (photoreceptor or sensor pixel) varies with Poisson fluctuation when the element is exposed to a photon flux of a particular wavelength. When an array of photoreceptors is exposed to multi-wavelength light energy, this photon fluctuation introduces a spatial variation in absorption by individual cells and a temporal variation in the number of cells at a given energy level. We propose a model to characterize such spatiotemporal variations in individual cells absorption. The performance of the model is evaluated by a CMOS sensor exposed repeatedly to a uniformly illuminated color patch. 

## Introduction to the code
This is a repository for estimating the histogram of absorbed light energy by individual like-type cells (pixels) of a particular type (class or channel) (e.g. R, G, B pixels or L-, M-, S-cones).  


### Prerequisites
You need MATLAB program installed. You may need to have "Psychtoolbox-3" functions installed (see [psychtoolbox](http://psychtoolbox.org/)).

Note : estimation of the pupil area from the stimulus luminance, in FIGURE_1_DEMO_MacAdam_Excitations_plt.m, calls a function from Psychtoolbox. 

```
[~ , pupil_area, ~] = PupilDiameterFromLum(stimulus_luminance)
```

## Distribution of light energy among cone cells (cone excitations)

In the *Code_File_1* folder, open and run *FIGURE_1_DEMO_MacAdam_Excitations_plt.m*. The required functions and data are all within the same folder. 

### Notes
In this code, FWHM is the Full width at half maximum of the three Gaussian primaries, used to match the 25 MacAdam (1942) colors, centered at the wavelengths specified in lambda_prim. 

```
FWHM = 65; lambda_prim = [450, 530, 655];
```
### Plots
The function *macLeod_boynton_chromaticity()* plots points within the MacLeod-Boynton (1979) excitation space.

```
macLeod_boynton_chromaticity([10, 5, 4], 0.001); (0.001 defines the size of a point within the plot).
```
The function *CIE_Judd_chromaticity()* plots points within the Judd-Vos modified CIE 1931 chromaticity space (Vos, 1978).

```
CIE_Judd_chromaticity([0.35 0.45 0.2], 0.01)
```

## Distribution of light energy among pixels of a sensor

### Materials
We captured 180 _*.raw_ images of a small classic xrite colorchecker, uniformly illuminated with a 1000 W quartz-halogen light bulb, using [AR0835HS 1/3.2" 8-megapixel CMOS digital sensor](http://www.onsemi.com/pub_link/Collateral/AR0835HS-D.PDF), manufactured by Aptina-ON Semiconductor. The spectral quantum efficiency functions of the sensor were digitized from the plot [(see p. 55)](http://www.onsemi.com/pub_link/Collateral/AR0835HS-D.PDF). The imaging device has a [SUNEX DSL945D-650 lens](http://www.optics-online.com/OOL/DSL/DSL945.PDF) with IR cuttoff filter. 

### Prerequisites
The required functions can be found in the *model_functions_eng_dist* folder. The sensor specifications files are stored in *sensor_data* folder.
To analyze the captured _*.raw_ images, first download [*Data_File.tar.gz*](https://github.com/peyvandi/raw-image-files.git) and save to the *image_data* folder. Then, unzip the file to extract 180 _*.raw_ images (*exposure_50ms<#>.raw*). Example of a typical image file:

```
exposure_50ms0008.raw  (50ms is the exposure duration, 0008-th image)
```

### Demo
Run the *demo_1_histogram_estimation.m* in the *Code_File_2* folder. In this demo, the variable *no_of_image_analyzed* takes the total number of images for the analysis. You may choose an integer upto 180, which is the total number of images captured by a CMOS sensor, [*Data_File.tar.gz*](https://github.com/peyvandi/raw-image-files.git). The function *img_RAW_read_bayer()* reads **.raw* files from *image_data* folder. The variable *select_patch* takes an integer between 1 to 24, referring to patches of the color checker.

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









