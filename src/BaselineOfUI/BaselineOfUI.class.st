"
This baseline is used to generate Pharo images from the local clone of pharo-project/pharo repository. 

Depends on:
- ConfigurationOfMorphic

Load type: 
- atomic

Installs:
- Spec
- Keymappings
- Rubric
- basic tools (old debugger, workspace)
- some other packages
"
Class {
	#name : #BaselineOfUI,
	#superclass : #BaselineOf,
	#classVars : [
		'Initialized'
	],
	#category : #BaselineOfUI
}

{ #category : #baseline }
BaselineOfUI >> baseline: spec [ 
    
	<baseline>

	| repository |
	 
	repository := self packageRepositoryURL.
       
	spec for: #common do: [
		spec postLoadDoIt: #'postload:package:'.
		
		"Loading the debugger model and infrastructure before the UI"		
		spec package: 'Debugger-Model'.
		spec package: 'Debugger-Oups'.

		"Load morphic before Spec"
		spec baseline: 'Morphic' with: [ spec repository: repository ].
		spec baseline: 'Spec2' with: [ 
			spec 
				repository: repository;
				loads: #('Base' 'Tests') ].
		spec baseline: 'Spec' with: [ spec repository: repository ].
		
		spec baseline: 'DrTests' with: [ spec repository: repository ].

		spec package: 'StartupPreferences'.		
		
		spec package: 'Debugger-Actions'.
		spec package: 'Debugger-Filters'.

		spec baseline: 'Fuel' with: [
			spec repository: repository; loads: 'Tools' ].

		spec package: 'Fonts-Chooser'.

		spec package: 'Transcript-Tool'.
		spec package: 'Tool-Workspace'.

		spec package: 'Morphic-Widgets-Tree'.

		spec package: 'Keymapping-Settings'.
		spec package: 'Keymapping-Tools-Spec'.

		spec package: 'WebBrowser-Core'.

		spec package: 'HelpSystem-Core'.

		spec package: 'EyeInspector'.
	].
]

{ #category : #actions }
BaselineOfUI >> postload: loader package: packageSpec [

	"Ignore pre and post loads if already executed"
	Initialized = true ifTrue: [ ^ self ].

	Smalltalk tools register: Workspace as: #browser.
	Smalltalk tools register: Workspace as: #monticelloBrowser.
	Smalltalk tools register: Workspace as: #fileList.
	Smalltalk tools register: Workspace as: #changeList.	
	
	Smalltalk ui theme settings preferGradientFill: true.
	PharoCommonTools initialize.

	Initialized := true
]
