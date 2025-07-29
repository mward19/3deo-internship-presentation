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

Goals to discuss. I did a lot in the internship, too many little things to explain, sticking to 3 biggest.


# Global registration
When scanning, we know where the points are with some error. INS drift, measurement error, etc. There are lots of good algorithms for pairwise.

(next)

but how do you use the pairwise transforms to get global?

(go through all the registration images)

If we had perfect pairwise transformations, this would be easy. (just d12 and d13) Just pick a target scan and move everything to it. 

(just d12 and d23)
We could also pick these.

(no points)
But what if d23 were different?

(weird d23)
like this? then if we trust it, and proceed to apply d12 (apply d12), it's all wrong. (points)

(graph) We can represent this problem as a mathematical graph. The nodes represent the positions of the scans, and the edges represent how to move the scans into alignment based on pairwise registrations. (unfortunately) But they don't always agree, as I showed earlier.

(pose graph) One way to solve this problem is by setting up a pose graph.
- Pairwise transformations are like springs. The pairwise registration is the length.
- Find the positions of the nodes that stretch the springs the least
- If we trust a pairwise registration less, we can make that spring stretchier so it doesn't throw off everyone else.

(minimization)
- we can set it up as a least squares minimization problem and solve for the best node positions
- but how do we decide how stretchy the springs are?

(points about stretchiness)
tried a few things. constant has worked best so far.

But I was only working with translations when I tried all that. with translations, least squares makes sense. 

(6d vector) Now we're working with rotations too. 

(euler angs pic) euler angles build on each other, so we can't just do naive least squares and get perfect results. rotations aren't euclidean. gets funky. So we're doing some Lie algebra stuff I don't know much about yet, but the least squares is still good intuition behind it.

(pruning and weighting)
After trying to make all the springs happy, if a spring is bad and disagrees with the others, it's probably no good.

Remove or weight less.

# Spot modeling