Just some presenter notes for me to use.

# Introduction
- Explain what ACME is
- BSG
    - Worked with tomograms
    - Learned some slurm, helpful in the internship
- music
    - getting into the pipe organ. piano, cello. like to write songs
- handball
    - not the team kind!

Goals to discuss. I did a lot in the internship, too many little things to explain, lots of little Acadia things, so I'm sticking to the 3 biggest.


# Global registration
When scanning, we only know where the points are within some expected error. INS drift, measurement error, etc. 

There are lots of good algorithms for pairwise registration that can help us mitigate that inevitable error. (3DEO cloud example)

(go through all the registration images)
- [3] Here are three misaligned point clouds.
- [4] They have some true poses -- where they "currently are" with respect to scan 1. Call these poses $X_1, X_2, X_3$.
- [5] If we had a perfect pairwise registration algorithm, we could find the transforms between the scans.
- [6] The transforms are really just vectors in $\mathbb{R}^2$ here, since we aren't doing rotations.
- [7] Since they're perfect, we don't need them all. Let's just use D12 and D13.
- [8] First we move scan 2 to where scan 1 is by applying D12 to all the points in scan 2.
- [9] Then we move scan 3 in the same way with D13.
- [10] We can instead use D12 and D23.
- [11] First we move scan 3 to scan 2.
- [12] Then we move _both scans 2 and 3, since they're both where scan 2 belongs now_, to scan 1 with D12.
- [13] We really can use any two pairwise registrations here. But if any of these pairwise registrations were wrong, how would we know which to use, and how do we harmonize the differences to get the best possible final position? In practice, the pairwise registrations never perfectly agree with each other, so this is a big problem.
- [14.1] As a graph, we might represent the scan positions as nodes and the pairwise registrations as edges. We wish that applying D23 and then D12 were the same as applying D13,
- [14.2] but this is not the case in practice.

[15.1] One way to solve this problem is by setting up a pose graph.
- Pairwise transformations are like springs. The pairwise registration is the length.
- Find the positions of the nodes that stretch the springs the least
- If we trust a pairwise registration less, we can make that spring stretchier so it doesn't throw off everyone else.

[15.2]
- we can set it up as a least squares minimization problem and solve for the best node positions
- but how do we decide how stretchy the springs are?

[16]
tried a few things. constant has worked best so far.

[17]
Setting this problem up as a pose graph gives us some useful tools. For example, after trying to make all the springs happy, if a spring is bad and disagrees with the others, it's probably no good and we can trash it or weight it less.

[18.1] In addition, this entire time, we've been imaging this in 2 dimensions. It's really in six, since it's a 3D space and we're working with rotations too. 

[18.2] Translations are nice and Euclidean and straightforward, but Euler angles build on each other,

[19] so we can't just do naive least squares and get perfect results. rotations aren't euclidean. gets funky. So we're doing some Lie algebra stuff I don't know much about yet, but the least squares is still good intuition behind it and it works pretty well. Let me show you results using the naive application of linear least squares. 

[20] [21]. So far this method has been extraordinarily effective at registering our point clouds. Allows us to encode rotation.

(a couple minutes for questions)
# Spot modeling
[22] Moving on, another project I worked on was that of modeling the illumination region in the camera's field of view. Knowing where that spot is in the camera's field of view and its size is quite useful for certain data analysis, like meaningful pointwise reflectivity estimates, as well as for the purpose of refining the tx-rx alignment and for other automatic quality control checks.

[23] We'll use data from this scan to talk about this in more depth.

[24.1] If I add up all of the photon detections for each pixel in this scan, I get this illumination spot. The laser seems t o be well aligned. The center of the camera's field of view had the strongest illumination, with the illumination decreasing as we approach the edges. 

[24.2] You might say it looks like a 2D Gaussian, or normal, distribution. That seems reasonable, and I assume it's what you hardware folks are going for.

[25] This spot is cumulative over the whole scan. But what if we were to look at the scan over time, frame by frame, as it's being taken? Let's watch an animation of the spot, averaging together the pixel hitmap for 30 frames at a time. 

(watch video) It moves. Still Gaussian, but it moves. I tried tracking this.

[26] First attempt was to use the photon detections in sets of 100 frames and fit a 2D gaussian to each set. (watch video) You might notice, as I do, that the mean is a little off. In addition, that band represents one standard deviation, and you may not notice now, but it is too tight. That's because there are samples we aren't seeing.

[27] Let's talk about why this happens. Here are 100 samples to simulate