"
A superclass for particular Spec demo pages, that need to define a page name and priority in the list of demos.
"
Class {
	#name : 'SpDemoPage',
	#superclass : 'SpPresenter',
	#instVars : [
		'tabManager'
	],
	#category : 'Spec2-Examples-Demo',
	#package : 'Spec2-Examples',
	#tag : 'Demo'
}

{ #category : 'accessing' }
SpDemoPage class >> availablePages [
	^ self allSubclasses sort: #priority ascending
]

{ #category : 'accessing' }
SpDemoPage class >> cloneDemo [
	"Clone the receiver in a new class and/or package to be selected by the user"

	self new cloneDemo
]

{ #category : 'initialization' }
SpDemoPage class >> pageName [

	self subclassResponsibility 

]

{ #category : 'initialization' }
SpDemoPage class >> priority [

	^ 999
]

{ #category : 'accessing' }
SpDemoPage >> application [
	"Private - Included as hook to support System Command execution for cloning an example"

	^ StPharoApplication current
]

{ #category : 'accessing - cloning' }
SpDemoPage >> cloneDemo [
	"Ask a new package name (use existing if already created) and a new class name where the receiver's behavior will be cloned"

	| toolContext resultPackage resultClass |
	toolContext := SpDemoToolContext for: self.
	resultPackage := (SycAddNewPackageCommand new asCommandActivator
		context: toolContext;
		executeCommand) command resultPackage.

	resultClass := (SycCopyClassCommand new asCommandActivator
		context: toolContext;
		executeCommand) command newClassName.
	
	(RBMoveClassTransformation 
		move: resultClass 
		toPackage: resultPackage name) 
			generateChanges.
	
]

{ #category : 'initialization' }
SpDemoPage >> codeFor: aClass [
	^ TonelWriter sourceCodeOf: aClass
]

{ #category : 'initialization' }
SpDemoPage >> codeTab [
	^ SpNotebookPage
		title: 'Code'
		icon: (self iconNamed: #changeUpdate)
		provider: [ self newText
				text: (self codeFor: self pageClass);
				yourself ]
]

{ #category : 'layout' }
SpDemoPage >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: tabManager;
		  yourself
]

{ #category : 'initialization' }
SpDemoPage >> exampleTab [
	^ SpNotebookPage title: 'Example' icon: (self iconNamed: #smallPaint) provider: [ self instantiate: self pageClass ]
]

{ #category : 'initialization' }
SpDemoPage >> initializePresenters [

	tabManager := self newNotebook.
	"tabManager whenTabSelected: [ self updateTitle ]."
	tabManager
		addPage: self exampleTab;
		addPage: self codeTab.
]

{ #category : 'accessing - cloning' }
SpDemoPage >> isPackageSelected [

	^ false
]

{ #category : 'accessing - cloning' }
SpDemoPage >> lastSelectedClass [
	"Private - Included as hook to support System Command execution for adding a new class"

	^ self pageClass
]

{ #category : 'initialization' }
SpDemoPage >> pageClass [

	self subclassResponsibility 

]

{ #category : 'accessing - cloning' }
SpDemoPage >> showClass: aClass [ 
	"Private - Included as hook to support System Command execution for adding a new class"

	| browser |
	browser := self application tools browser.
	browser openOnClass: aClass.
		
]

{ #category : 'accessing - cloning' }
SpDemoPage >> showPackage: aPackage [ 
	"Do nothing, let to class cloning operation to open a new tool"

]

{ #category : 'accessing - cloning' }
SpDemoPage >> systemEnvironment [
	"Answer an object used to create pacakges. Included as hook to support System Command execution for adding a new package"
	
	^ PackageOrganizer default
]

{ #category : 'accessing' }
SpDemoPage >> tabManager [
	^ tabManager
]

{ #category : 'accessing' }
SpDemoPage >> tabManager: anObject [
	tabManager := anObject
]
