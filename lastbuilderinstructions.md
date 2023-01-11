# LastOS Builder Document version 1.0

![<Lastos logo>](<https://cldup.com/E21ACrr4ZJ.png?raw="true" width="100px"  height="100px">)

## For Lastbuilder20 Version 1.01

## 1.0 Preparation for Last20 Build

* Make sure to use an original untouched Microsoft ISO to base your build on, this will make the LivePE's stable, SysPrep's smaller and less debugging issues.

[download Windows 11 here from microsoft](https://www.microsoft.com/en-au/software-download/windows11)

### 1.1 Use an Original Windows ISO

Copy an Original Windows ISO to "\00_Source" directory

### 1.2 MountISO

Edit the file contents of \Settings\MountISO.txt to the ISO file name.
This ensures that the builder can find the correct ISO file.
Tip you can use a project name, for example

* note: don't use spaces use underscore '_' as a seperator

    Last20_Win11_Jan23
	
	or Camel Case
	
	Last20Win11Jan23

the filename structure should be {project name}{windows version}{date}

Use the following cmd file to rename the ISO for the builder to use:

    00.0_Rename_First_ISO_To_Windows_Original_ISO.cmd 

### 1.3 Extract Sources

Use the following cmd file to extract sources from the ISO as designated by the contents of MountISO.txt file:

 00.1_Extract_Source_ISO.cmd

This extracts the files from the ISO in "\00_Source",
into the following directories under "\00_Source":

* 01Windows_Original
*  02Windows_Sysprep
*  03Windows_NTLite
 
this will allow the addition of files such as drivers etc

## 2.0 VirtualBox

Use the following cmd file to run VirtualBox:

 01.1_Execute_VirtualBox.cmd

This will create a virtual hard drive based on the contents of "02Windows_Sysprep" directory and
the contents of the Virtual Hard Drive text files in \Settings\ directory and run VirtualBox.
 
* note: now self elevates to Administrator or quits if canceled

Ensure VirtualBox application v7 or later is installed

* note: Default capture key of VirtualBox is the right side Ctrl key

## 2.1 Preparation for Sysprep

Use Last20 Builder scripts

or, by using a clean/official OS ISO, start the install to any VM with a (MBR) single partition NTFS formatted VHD, this will allow you to mount it to your real OS to capture it later.

1.Run "01.1_Execute_VirtualBox.cmd"
2.Once VirtualBox starts, in the Virtual box window, press a key to boot from the above OS ISO.

3.Install your Base Version of Windows to  the pre-formatted partition (do NOT make new partitions or changes).
4.When the windows installation gets to the first OOBE screen (Set Languages/Users etc), press Ctrl+Shift+F3 to enter Audit Mode.

![<oobe>](https://cldup.com/nLPG5dMZpK.png)

## Virtualbox cleanup

~~~~~~~~~~ Step 3.Run 01.2_Update_Clean_VirtualBox.cmd (This will start the VirtualBox if not already running)
* This will prepare, update and clean your Virtual OS ready to capture it, you can boot the VM again once Generalized/OOBE and press Ctrl+Shift+F3 to enter Audit Mode again to re-update/edit your captured OS's using this script to start it.

* You can close the "System Preparation Tool 3.14" window every boot as I include a script to finalize and shutdown the VM

* You may need to update the included version of Dot.NET 3.5 cab file off the \00_Source\01Windows_Original\sources\sxs\microsoft-windows-netfx3-ondemand-package~####~amd64~~.cab only the version made for your OS version will work. Alternatively you can install it manually with ticking .NET 3.5 in Windows Features and it will download the right one for you.

1.Run "01.2_Update_Clean_VirtualBox.cmd"
2.In Virtual Machine press WIN+R and type "explorer", click on "This PC" and open CD Drive (D:) 01Update_CleanVM
* You can run any of the scripts you need but I have provided automated scripts at the bottom of the list.
3.Run "zz_Automate_1_TweaksToGamer.cmd", Press Disable Windows Defender" when asked, close the windows once done/red. This step will apply overlays, install runtimes, tweaks and DirectX.
4.Run "07_Update_WUMT.cmd" and press Check for update (2 Arrows on left), select all updates you want (Defender and Malicious Software Updates shouldn't be installed/included in a Sysprep OS). Press the "Install Updates" button (Down Arrow with Line under) and wait for updates to complete (asks for reboot)
5.Press Reboot to reboot the VM. * You may want to re-check for updates (Repeat step 4 + 5) if you suspect any issues occured. * The reboot may fail to happen after certain updates and you will have to use the start menu to reboot the VM.
6.Run "zz_Automate_2_Cleanups.cmd", this can take up to 2 HOURS to clean your system, the slowest steps are the Update Cleanups and the ReBase of the OS, this step also saves you GB's of disk space and speeds up the installation of the captured OS.
7.Run "zzzz_SysPrep_OOBE_Generalize_Shutdown.cmd" or switch to and Change "System Preparation Tool 3.14" drop downs combos to "Enter System Out-of-Box Experience (OOBE)", "Shutdown" and tick the Generalize box. Press Ok to shutdown the VM.


~~~~~~~~~~ Step 4.Run 01.3_Capture_SysPrep_WIM.cmd
* Make sure you do NOT have any Antivirus or defender running, also close WizFile/Everything or any other software that may try to access your Virtual HDD. This may damage your Virtual HDD image and stop/slow down the capture. 

* Wait until the VM has fully ShutDown

1.Run "01.3_Capture_SysPrep_WIM.cmd"
2.Edit the Mounted Virtual Drive if you need to before pressing a key to capture the install.wim


~~~~~~~~~~ Step 5.NTLite (This job is partially Automated by the script, but you can use any version and preset of NTLite)
* Use the script to update the Settings.XML at least once before you run NTLite manually, I offer the Last20 preset as WIM or ESD, if your only testing and in a hurry use WIM, for the final ISO build you really want to use ESD to save a bunch of disk space.

* If you mess up your NTLite you can copy the entire Sysprep ISO using "02.0_Delete_NTLite_Copy_SysPrep_ISO_To_NTLite_ISO.cmd"

1.Run "02.1_Copy_SysPrep_WIM_To_NTLite_ISO.cmd" this will copy the SysPrep's capture install.wim to the NTLite Folder
2.Run "02.2_NTLite.cmd" This will Prepare NTLite to use the folders the scripts make.
3.In NTLite double click on the install.wim to mount it (make it green).
4.In NTLite double click the Last20 preset you want to use.
5.Go to Apply and click Process (top Left), Close NTLite once completed.


~~~~~~~~~~ Step 6.WinBuilder (This job produces Live OS and makes the final  ISO)
* The WinBuilder project contains the PE and ISO overlay's

1.Run "03.0_Edit_ISO_Overlay.cmd" - If you need to this will open up the Folder that gets copied to the final ISO.
2.Run "03.1_Copy_install.esd_wim_To_Overlay.cmd", This will delete any existing install.esd and/or wim and copy them from the NTLite ISO path. *It's up to you to make sure you only have one or the other in the final NTLite ISO image.
3.Run "03.1_Clean_WinBuilder.cmd" (only need to do this if you change a option in WinBuilder, else you can just build your ISO with it's existing WinRE)
4.Run "03.2_ssWPI_Generate.cmd" - This will silently make the ssWPI_DB's for faster load times (Run this if you add or remove apps).
5.Run "03.3_WinBuilder.cmd"
6.Press the top Tree item and pick "Select the Windows Source Folder", Browse and find the "\00_Source\01Windows_Original" folder, press ok.
7.Edit anything you want to and press the big blue play button.
8.Run "03.4_Rename_ISO.cmd" - The ISO file will be created with your Project Name from Settings. Explorer will open to the folder it's in.

Job Done!


---------------------

00.0_Cleanout_Last20_Builder.cmd - Start Again:
You can run "00.0_Cleanout_Last20_Builder.cmd" to wipe everything except the Original Windows ISO file you supplied. It will leave all your modified settings, but none of the build or produced ISO's, so make sure you copy/move them out somewhere safe, do NOT leave completed Build ISO's in the Builder folders.

99.0_Make_New_01Update_CleanVM.iso.cmd - Updated or changed 01_Syspreping\01Update_CleanVM folder contents:
Run "99.0_Make_New_01Update_CleanVM.iso.cmd" to make the new 01Update_CleanVM.iso again from the folder content

zzzz_Missing_Files.txt:
This is a list of the extra files I include in my build that are not included in this release, they were remove to reduce size and copyrighted content.

00.0_Delete_Source_ISO_Clean_Up_Builder.cmd:
This script will empty the entire 00_Source folders, you only need supply a Original ISO for it to populate the required folders.

00.0_Delete_Source_NTLite_Copy_Sysprep_ISO.cmd:
This script will erase an existing NTLite ISO and copy your Sysprep ISO folder back to it so you can run NTLite again (with your changes).

02.0_Delete_NTLite_Copy_SysPrep_ISO_To_NTLite_ISO.cmd:
This is same as the above script but has a pause at the end so you can debug problems with it.
