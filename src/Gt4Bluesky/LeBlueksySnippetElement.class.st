Class {
	#name : #LeBlueksySnippetElement,
	#superclass : #LeTextualSnippetElement,
	#instVars : [
		'contentElement',
		'inputElement',
		'viewElement',
		'toolbarElement',
		'editUrlButton',
		'cancelButton',
		'errorLabelElement',
		'identityElement',
		'publishButton'
	],
	#category : #'Gt4Bluesky-Snippet'
}

{ #category : #accessing }
LeBlueksySnippetElement >> contentElement [
	<return: #BrFrame>
	^ contentElement
]

{ #category : #accessing }
LeBlueksySnippetElement >> editor [
	"Required by ${method:LeTextualSnippetElement>>#registerFocusEventHandlers}$"
	^ self inputElement
]

{ #category : #accessing }
LeBlueksySnippetElement >> initialize [
	super initialize.

	self initializeContentElement.
	self initializeToolbarElement.
	
	self padding: (BlInsets all: 5)
]

{ #category : #accessing }
LeBlueksySnippetElement >> initializeContentElement [
	contentElement := BrFrame new
			vFitContent;
			hMatchParent.

	inputElement := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			vExact:200.
	inputElement visibility: BlVisibility visible.
	inputElement
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | self onTextInputModified: anEvent ].

	LeSnippetEditorElementShortcuter new
		editor: inputElement;
		indent;
		moveUpAndDown;
		loseFocus.

	contentElement addChild: inputElement as: #editor.

	LeSnippetEditorElementShortcuter new
		editor: inputElement;
		indent;
		moveUpAndDown;
		loseFocus
]

{ #category : #accessing }
LeBlueksySnippetElement >> initializeToolbarElement [
	toolbarElement := BrToolbar new
			aptitude: BrGlamorousToolbarAptitude;
			hMatchParent;
			vFitContent.

	publishButton := BrButton new
			beTinySize;
			aptitude: BrGlamorousButtonWithIconAptitude;
			icon: BrGlamorousVectorIcons accept;
			label: 'Publish';
			disable;
			action: [ :aButton | self onPublishAction: aButton ].

	toolbarElement addItem: publishButton.

	cancelButton := BrButton new
			beTinySize;
			aptitude: BrGlamorousButtonWithIconAptitude;
			icon: BrGlamorousVectorIcons cancel;
			label: 'Cancel changes';
			visibility: BlVisibility gone;
			action: [ :aButton | self onCancelAction: aButton ].

	toolbarElement addItem: cancelButton.

	errorLabelElement := BrLabel new
			id: LeGitHubErrorMessageElementId;
			aptitude: (BrGlamorousLabelAptitude new foreground: BrGlamorousColors errorBackgroundColor);
			text: '';
			vFitContentLimited;
			vFitContent;
			hMatchParent.



	toolbarElement addItem: errorLabelElement.

	identityElement := BrButton new
			label: 'Not logged in';
			aptitude: BrGlamorousButtonWithLabelAptitude
					+ (BrGlamorousWithDropdownAptitude
							handle: [ BrButton new
									label: 'Login';
									aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude ]
							content: [ (GtBlueskyLoginForm new
									clientCallback: [ :aClient | 
										self snippet client: aClient.
										identityElement
											inUIProcessDo: [ identityElement dispatchEvent: BrDropdownHideWish new ] ])
									asElement padding: (BlInsets all: 8) ]).

	toolbarElement addItem: identityElement
]

{ #category : #accessing }
LeBlueksySnippetElement >> inputElement [
	^ inputElement
]

{ #category : #accessing }
LeBlueksySnippetElement >> inputElement: anObject [
	inputElement := anObject
]

{ #category : #accessing }
LeBlueksySnippetElement >> onClientChanged [
	self snippet client isLoggedIn
		ifTrue: [ identityElement label: self snippet client handle.
			publishButton enable ]
]

{ #category : #accessing }
LeBlueksySnippetElement >> onPublishAction: aButton [
	| record |
	"self uploadFiles."
	record := {'$type' -> AppBskyFeedPostMain atpRecordName.
			'createdAt' -> DateAndTime now printString.
			'text' -> inputElement text asString} asDictionary.
	"self fileRecords ifNotEmpty: [ record at: 'embed' put: self filesToEmbed ]."

	"self snippet hasPost
		ifTrue: [ | root |
			root := self snippet post getRoot.
			record
				at: 'reply'
				put: {'parent'
							-> {'uri' -> self snippet post atpPost atpUri.
									'cid' -> self snippet post atpPost atpCid} asDictionary.
						'root'
							-> {'uri' -> root atpPost atpUri.
									'cid' -> root atpPost atpCid} asDictionary} asDictionary ]."

	self snippet client
				comAtprotoRepoCreateRecordRepo: self snippet actor atpDid
				collection: AppBskyFeedPostMain atpRecordName
				rkey: nil
				validate: nil
				record: record
				swapCommit: nil
]

{ #category : #accessing }
LeBlueksySnippetElement >> onSnippetViewModelChanged [
	super onSnippetViewModelChanged.
	self onClientChanged
]

{ #category : #accessing }
LeBlueksySnippetElement >> snippetContent [
	"Return an element that represents a content of the snippet.
	The embedder is responsible for placing #snippetContent in the right place within snippet element depending on the
	View Model properties and derived look"
	<return: #BlElement>

	^ self contentElement
]

{ #category : #accessing }
LeBlueksySnippetElement >> snippetToolbar [
	"Return an element that represents a toolbar of the snippet. A toolbar usually appears below the snippet content.
	The embedder is responsible for placing #snippetToolbar in the right place within snippet element depending on the
	View Model properties and derived look.
	If returned #snippetToolbar is nil, no toolbar will be added"
	<return: #BlElement or: nil>

	^ self toolbarElement
]

{ #category : #accessing }
LeBlueksySnippetElement >> subscribeToSnippetViewModel [
	super subscribeToSnippetViewModel.

	self snippetViewModel
		when: LeBlueskySnippetClientChanged
		send: #onClientChanged
		to: self
]

{ #category : #accessing }
LeBlueksySnippetElement >> toolbarElement [
	<return: #BrToolbar>
	^ toolbarElement
]
