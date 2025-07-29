#show image: set align(center)
#show link: set text(blue)
#show figure: set block(breakable: true)

= Background on spot normalization
A point cloud $cal(P) in RR^(N times 3)$ from our lidar data has some weird sweeping patterns. If I were to plot the local density of points from the sky it would look like this:
#figure(caption: [Snaking pattern])[#image("img/image.png", width: 40%)] <snake>
where blue represents regions of higher density.

This is because of the path our lidar sensor scans in, and the way it illuminates a given area. 

#image("img/spot.svg", width: 110%)

The blue and red spots move more or less together in a snaking pattern over the target, as in @snake. At times, they may not be perfectly aligned, as depicted below:

#image("img/spot-misaligned.png", width: 65%)

Due to the snaking pattern and misalignment, certain spots on the target surface might have higher probability than others of being observed. Given the sensor observation region, the laser illumination region, and the snaking pattern all over time, we would like to model the probability that a given spot on the ground is observed. Then we can normalize our data's density by that probability, yielding a more meaningful density measurement.

#pagebreak()
#align(center)[
    = Approach
]

== Setup
=== Assumptions

We assume the region that the laser illuminates is a spot with a Gaussian distribution (#link("https://en.wikipedia.org/wiki/Gaussian_beam")[Wikipedia, Gaussian beam]). Our samples of this region come through the camera, but the region the camera can observe is limited, so what we observe is a 2-dimensional #link("https://en.wikipedia.org/wiki/Truncated_normal_distribution")[truncated Gaussian distribution]. We already know the bounds of truncation since we know how many pixels are in the sensor grid. We want to learn the mean and covariance of the illumination spot throughout the scan.

In the scan, we think the intensity of the laser doesn't change, but due to misalignment, the position of the mean will change. The covariance might change too. 

=== Hitmaps
At each frame, 20 to 30 percent of the pixels in the sensor record a hit. A _hitmap_ is a matrix where each element represents a pixel in the sensor grid, with 1 representing a hit and 0 representing no hit in a frame. By aggregating hitmaps from consecutive frames together we can estimate the illumination region within an interval of time. To perform such modeling I used a window size of 100. In other words, to model the illumination spot at frame 300, I used data from frames 250 through 349.

== GMMis

A common tool for estimating the mean and covariance of a Gaussian given some samples is #link("https://scikit-learn.org/stable/modules/mixture.html#expectation-maximization")[expectation maximization] via Gaussian mixture models (GMMs). However, since our data is truncated, we saw that using GMMs naively gave our estimated means a bias towards the center and the estimated covariances shrunk too small. Some astronomers faced a similar problem with their data and created a modified expectation maximization procedure to solve this and other problems, and released their code under the MIT licence as pygmmis (#link("https://arxiv.org/abs/1611.05806#")[Filling the gaps: Gaussian mixture models from noisy, truncated or incomplete samples]). See @pygmmis.

#figure(
    caption: "From pygmmis project on GitHub: \"In the example above, the true distribution is shown as contours in the left panel. We then draw 400 samples from it (red), add Gaussian noise to them (1,2,3 sigma contours shown in blue), and select only samples within the box but outside of the circle (blue).\""
)[#image("img/gmmis.png")] <pygmmis>

It solved the issues we were facing with biased means and covariances, as shown in @biased-spot. 

#figure(
    caption: [In both images above, the underlying heatmap, which contains 100 hitmaps averaged together, is the same. The red dot is the estimated mean, and the ellipse marks one standard deviation. *Left*:~Gaussian spot modeled using standard GMM with one component. *Right*:~Gaussian spot modeled with pygmmis. The mean is lower, where one would expect, and the covariance is much larger.]
)[
    #grid(
        columns: (55%, 55%),
        image("img/biased_gaussian.jpg"  , width: 115%),
        image("img/unbiased_gaussian.jpg", width: 115%)
    )
] <biased-spot>

=== Results
To apply GMMis to estimate means and covariances over a whole scan, we do the following:
#align(center)[#block(stroke: black, radius: 1em, inset: 1em, width: 85%)[
  Algorithm 1
  #set align(left)
  - Fix a window width $w in NN$ to be the number of hitmaps we aggregate to infer the spot distribution at a given frame. I used $w = 100$.

  - Throw out 95% of the data at random (for speed).

  - For each frame:

    - Collect together all pixel hits in the window around this frame.

    - Fit a GMMi model to them.

      - For each model, clarify in the settings that for a hit point from pixel $(x, y)$, we know that $0 <= x < n_x$ and $0 <= y < n_y$ where the pixel grid is $n_x times n_y in NN times NN$ pixels. 

    - Extract the estimated mean and covariance from the model. 
] <alg-1>] 

Applying this method over an entire scan, we saw that the mean of the illumination spot tended to move up and down with perfect periodicity. See a brief animation #link("https://drive.google.com/file/d/1duZvtSX1u8ZsmpDblcnPBwNqvhDSStC4/view?usp=sharing")[here], and a plot of this phenomenon in @spot-plot.

#figure(
    caption: [The $y$ position of the illumination spot's mean moves periodically.]
)[
    #image("plots/gaussian_model_time_series.png", width: 110%)
] <spot-plot>

It's too slow, though. Even after throwing out 95% of hits, fitting the GMMi models takes around 5 minutes for one scan on my laptop with 32 gb RAM and an Intel Ultra 9. 

== Modifying method for efficiency
One can see in @spot-plot that the mean oscillates back and forth, while the covariance stays more or less the same (with noise). Each time we fit a GMMi model, we are recalculating the full distribution parameters, but in reality, many of the parameters stay the same. (I think pygmmis has a way I can encode this... maybe I should try doing that too.)

A modified algorithm vastly sped up the modeling process:
#align(center)[#block(stroke: black, radius: 1em, inset: 1em, width: 85%)[
  Algorithm 2
  #set align(left)
- Fix a window width $w in NN$ to be the number of hitmaps we aggregate to infer the spot distribution at a given frame. I used $w = 100$.

- (Unlike before, keep all the data.)

- Estimate constant illumination spot covariance.

  - Randomly sample $k$ window positions. I used $k=3$.

  - In each of those window positions, fit a GMMi model to the data in the window, and save the resulting covariance.

  - Estimate the actual covariance by averaging together the $k$ covariances just calculated.

- Calculate the spot's mean at each frame. (Actually, every $n$ frames. We can interpolate to find the values in between. I used $n = 50$.) For each frame:

  - Average together hitmaps for all frames in this frame's window, and call it the _average hitmap_.

  - Apply a strong Gaussian blur to the average hitmap. #text(red)[TODO: refine this explanation]

    - Blurring too much would bias the position of the maximum, and not blurring enough means there are too many local maxima. 

    - Blurring evenly in all directions caused too much blurring in one direction while there still wasn't enough in the other. 

    - The Gaussian spot had much greater variance in one axis than the other, as seen in @biased-spot. To account for this, when applying Gaussian smoothing, I kept the ratio of blurring in one axis to the other the same as the ratio of the diagonal elements of the covariance matrix. 

  - Since the mean of a Gaussian is where the distribution's density is maximized, estimate the mean as the position where the blurred average hitmap is maximized.
] <alg-2>]

We found that Algorithm 2, while much faster than Algorithm 1, yielded means with a bit more fluctuation and bias. The means did not fluctuate so much as to cause serious issues for our purposes, though. See @gmmi-blur-comparison.

#figure(
  caption: [Comparing various spot illumination models. The lines labeled \"GMMis\" were calculated with Algorithm 1, and the rest were calculated with Algorithm 2, with various $sigma$ settings controlling the degree of blurring. The blue "GMMis" lines can be considered the truth, and the other "Blurred" lines an approximation of that truth. One can see that different $sigma$ values had generally similar results, with higher $sigma$ values performing a bit better since they have less bias in the mean. #text(red)[TODO: Investigate off-by-one issue]]
)[
  #image("plots/gaussian_and_blur_multi_sigma_models_time_series.png", width: 110%)
] <gmmi-blur-comparison>
