# Modding Minecraft 

> For using with IntelliJ 
To start adding your own mods into Minecraft follow the below steps to set up your environment:

## Opening Intelli

Open the VNC link shown on your workspace 

When the desktop screen appears, navigate to the menu and search for IntelliJ Idea

When prompted load in the minecraftforge directory

`home/ii/minecraftforge` 


## Set up the runClient 
- Follow the below steps to set up the runClient by clicking on the icons shown below:

- CLick add configuration

![Screenshot from 2023-05-08 18-13-33](https://user-images.githubusercontent.com/59022024/236748505-fb151c0f-d68f-42b3-9e92-fa9b45599c60.png)


- Click the `+` icon

![Screenshot from 2023-05-08 18-14-02](https://user-images.githubusercontent.com/59022024/236748517-94c05ee0-275e-4504-8088-8297f3f519c3.png)

  * [ ] > Choose gradle

![Screenshot from 2023-05-08 18-14-27](https://user-images.githubusercontent.com/59022024/236748526-b975d49a-0a8f-4ab9-8f9a-45e5eeb9f1ac.png)

- Type runClient in both boxes

![Screenshot from 2023-05-08 18-31-15](https://user-images.githubusercontent.com/59022024/236754482-99b5218a-3a4b-4ce5-a26b-73ea550c245f.png){ width: 400px; }

## Running the mods 
- To start minecraft: Click on the play button as shown in the image below

![Screenshot from 2023-05-08 18-18-33.png…](https://user-images.githubusercontent.com/59022024/236751626-395248f6-4ff5-4aa7-b60a-d4116cd32532.png){ width: 400px; }


- When creating your world makesure it's in creative mode by clicking on 'survival mode' until it changes to creative 

![Screenshot from 2023-05-08 18-18-33](https://user-images.githubusercontent.com/59022024/236755602-729c1abb-d8fe-4da2-a3b5-73e991cb108f.png){ width: 400px; }

## Another way 
If you just want to play the game you can navigate to the desktop menu and search Minecraft 

It might take a while to load and look like not much is happening but it is! to see what programs are running open the kitty terminal 

in the command line, type `htop` to start the htop program and see what the system is doing under the hood.



## Starting the mouse-control script. 
- To be able to play minecraft smoothly we need to use a script which converts key presses into mouse track movement

- Open the kitty terminal

`cd mouse-controls`

Then:

`python mouse-controls.py`

- The current keybindings are: 

`Up Left Right Down` arrow keys to pan the camera
`w` - move forward 
`a` - move left
`s` - move down
`d` - move right 
`Enter` - mine the blocks 
`f` - places blocks 

if the camera starts spinning uncontrollably return to the terminal and makesure there is no errors that have been returned by the script, if there is, just re-run the script by following the above commands. 

#### In minecraft you need to turn off the `raw input`

- press `esc` to bring up the menu then navigate to: options > controls > mouse settings > raw input and switch it to off

### Getting chat items
- press `t` to open the chat box 
- then type `potato` Or `diamond` 

![Screenshot from 2023-05-08 18-27-08](https://user-images.githubusercontent.com/59022024/236753530-7b3b8007-57e9-4a9f-97bc-5c51536f7e37.png){ width: 400px; }
![Screenshot from 2023-05-08 18-27-50](https://user-images.githubusercontent.com/59022024/236753547-1a908040-1811-406f-b212-7730a0672f6b.png){ width: 400px; }


### Spawning elder dragon!
- bring up the chat menu again by pressing `t`
- then type `/give Dev minecraftdragon_egg`

![Screenshot from 2023-05-08 18-28-55](https://user-images.githubusercontent.com/59022024/236752357-84da0cb4-98a3-461a-900a-c963eb1228ba.png){ width: 400px; }

- To spawn a dragon, select the egg from your inventory and place in the world, watch as it flys away!
![Screenshot from 2023-05-08 18-29-41](https://user-images.githubusercontent.com/59022024/236753916-c97e35cc-6363-4c1b-bcfb-10b9f45550c9.png){ width: 400px; }


### Skeleton war 
- press `e` to bring up the menu, click the top right icon to search
- in the search bar type `skeleton spawn`
- drag egg to the hotbar in inventory window
- place a bunch in the world to start a war!

### Snowball arrows
- press `e` to bring up the menu, click the top right icon to search
- in the search bar type `snowball`
- drag snowball to the hotbar in inventory window
- throw the snowballs and they will turn into arrows

### Overpowered Iron Golems
- pull up the command line using `t`
- Spawn an Iron Golem by using the command `/summon minecraft:iron_golem`

### Turn to night
- pull up the command line using `t`
- Change the time via `/time set day`
