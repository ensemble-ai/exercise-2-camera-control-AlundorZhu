# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Sween Zhou
* *email:* swzhou@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera is always centered on the vessel. The cross is 5 by 5 and is drawn clearly. The movement is very smooth. Perfect!

___
### Stage 2 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The vessel isn't moving with the camera. It'll slowly lag behind if you just stand still, that's the only issue I found, a minor one. Everything else works correctly! The camera is scrolling at a constant speed, and the vessel collides with the edges.

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The lerp smoothing is correctly implemented. You have an if statement in your code that checks which speed should be used for the camera. When the vessel is moving, follow_speed is used. When the vessel is beyond the leash_distance, the camera will move towards the vessel to stay at the leash_distance. When the vessel isn't moving, catchup_speed is used. You also draw the cross, which is nice.

___
### Stage 4 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera is moving at a speed faster than the vessel's. I thought you didn't have the delay for the camera to catch up when the vessel stops moving, but then I realized your catchup_delay_duration is set to 0.05, so I had to manually change it to a larger number for the delay to be noticable. It's working correctly for the most part, but in either case, if you move to a direction, say, to the right, and then suddenly change that direction to the left when it's at the leash_distance, the vessel is stuck at the leash_distance and the camera doesn't come back to the center and move to the new direction.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
Your implementation looks unfinished. You draw the boxes, but nothing happens when the vessel moves in the speedup zone, and the push is glitched when hitting the outside edges.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
I think there aren't many infractions in your code except occasionally there might be a few uneccssary extra spacing between the lines. For example, in the process function of your linear_interpolation.gd, you have [2 empty lines](https://github.com/ensemble-ai/exercise-2-camera-control-AlundorZhu/blob/610c090204a2a4984abacf1ad78d9002d2e01609/Obscura/scripts/camera_controllers/linear_interpolation.gd#L22) between the variable and the if statement. Also, at the end of your _process function in auto_scroll.gd, you [indent the last line](https://github.com/ensemble-ai/exercise-2-camera-control-AlundorZhu/blob/610c090204a2a4984abacf1ad78d9002d2e01609/Obscura/scripts/camera_controllers/auto_scroll.gd#L43) and the line doesn't have any code.

#### Style Guide Exemplars ####
Your variable and function names follow the underscore naming convention, and your class names follow the Camel naming convention. The names are very specific, which makes it a lot easier to go through the main logic of your code because I can get a sense of their purposes already beforehand just by reading the names.
___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
You have a separate script for each type of camera, which is really nice, but some of the code are redundant. For example, your draw_logic functions are mostly the same. I think one way to fix that is to move the code to your base camera or push box class. You can split the draw logic into two functions, one for drawing the box, and the other one for the cross. You can also have your cameras extend each other instead of directly from the base class, because some of the cameras like lerp smoothing and lerp target focus are really similar. You can make functions for code that you are reusing in the parent class, that way you don't have to copy the same big chunks of code for every camera.

I notice that when I switch between the cameras, the transition is sometimes bugged. For example, when I stop moving and switch from lerp smoothing to lerp target focus at the same time, the vessel just dissappears and the camera is moving by itself.

You don't have to [set position to target.position in _ready()](https://github.com/ensemble-ai/exercise-2-camera-control-AlundorZhu/blob/610c090204a2a4984abacf1ad78d9002d2e01609/Obscura/scripts/camera_controllers/linear_interpolation.gd#L12) because all the movements are computed in terms of global_position and the needed initialization is already there in the base class.

In your lerp target focus, you don't need to [free the timer every now and then](https://github.com/ensemble-ai/exercise-2-camera-control-AlundorZhu/blob/610c090204a2a4984abacf1ad78d9002d2e01609/Obscura/scripts/camera_controllers/lerp_target_focus.gd#L50). You can restart the timer whenever the vessel stops moving and ignore it if the vessel starts to move again and make it so that catching up is only allowed when time_left is at 0.

#### Best Practices Exemplars ####
Your code for the most part is very easy to follow. The variables all have their types specified. Good use of if statements as well. I also notice you're commiting quite frequently, which is nice.