Class {
	#name : #LeBlueskySnippetElement,
	#superclass : #LeTextualSnippetElement,
	#instVars : [
		'contentElement',
		'inputElement',
		'viewElement',
		'toolbarElement',
		'editUrlButton',
		'errorLabelElement',
		'identityElement',
		'publishButton',
		'replyButton',
		'deleteButton',
		'headerElement',
		'authorNameLabel',
		'authorHandleLabel',
		'dateLabel',
		'profilePicture',
		'addFileButton',
		'files',
		'fileRecords',
		'imageContainer',
		'parentProfilePicture',
		'parentAuthorNameLabel',
		'parentAuthorHandleLabel',
		'parentDateLabel',
		'postInfoElement',
		'parentInfoElement'
	],
	#category : #'Gt4Bluesky-Snippet'
}

{ #category : #accessing }
LeBlueskySnippetElement >> buildGrayLabel [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new
			foreground:  Color lightGray)
]

{ #category : #accessing }
LeBlueskySnippetElement >> contentElement [
	<return: #BrFrame>
	^ contentElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> createAddFileButton [
	^ addFileButton := BrButton new beSmallSize
			aptitude: BrGlamorousButtonWithIconAptitude new
					+ (BrGlamorousWithDropdownAptitude
							handle: [ BrButton new
									beSmallSize;
									aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
											- BrGlamorousButtonExteriorAptitude;
									icon: BrGlamorousVectorIcons add ]
							content: [ BrFileSelector new
									vExact: 250;
									hExact: 400;
									folder: FileLocator home;
									padding: (BlInsets all: 8);
									fileFilterBlock: [ :aFileReference | 
										aFileReference isDirectory not
											and: [ (FileSystemDirectoryEntry reference: aFileReference) isHidden not ] ];
									okAction: [ :aFile | 
										self files add: aFile.
										addFileButton
											inUIProcessDo: [ addFileButton dispatchEvent: BrDropdownHideWish new.
										self updateFileContainer ] ] ]);
			icon: BrGlamorousVectorIcons add;
			label: 'Add File'
]

{ #category : #accessing }
LeBlueskySnippetElement >> createImageContainer [
	^ imageContainer := BrHorizontalPane new
			hMatchParent;
			vExact: 200;
			visibility: BlVisibility gone;
			margin: (BlInsets all: 5)
]

{ #category : #accessing }
LeBlueskySnippetElement >> editor [
	"Required by ${method:LeTextualSnippetElement>>#registerFocusEventHandlers}$"
	^ self inputElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> fileRecords [
	^ fileRecords
]

{ #category : #accessing }
LeBlueskySnippetElement >> fileRecords: anObject [
	fileRecords := anObject
]

{ #category : #accessing }
LeBlueskySnippetElement >> files [
	^ files
]

{ #category : #accessing }
LeBlueskySnippetElement >> files: anObject [
	files := anObject
]

{ #category : #accessing }
LeBlueskySnippetElement >> filesToEmbed [
	^ {'$type' -> 'app.bsky.embed.images'.
		'images'
			-> (self fileRecords
					collect: [ :aRecord | 
						{'image' -> (aRecord at: 'blob').
							'alt' -> ''} asDictionary ]) asArray} asDictionary
]

{ #category : #accessing }
LeBlueskySnippetElement >> initialize [
	super initialize.


	files := OrderedCollection new.
	fileRecords := OrderedCollection new.

	self initializeContentElement.
	self initializeToolbarElement.

	self padding: (BlInsets all: 5)
]

{ #category : #accessing }
LeBlueskySnippetElement >> initializeContentElement [
	contentElement := BrVerticalPane new
			vFitContentLimited;
			hMatchParent.
			
	contentElement addChild: self initializeHeader.

	inputElement := BrEditor new
			aptitude: BrGlamorousRegularEditorAptitude;
			vExact:50.
	inputElement visibility: BlVisibility visible.

	LeSnippetEditorElementShortcuter new
		editor: inputElement;
		indent;
		moveUpAndDown;
		loseFocus.

	contentElement addChild: inputElement as: #editor.

	contentElement addChild: self createImageContainer
]

{ #category : #accessing }
LeBlueskySnippetElement >> initializeHeader [
	headerElement := BrVerticalPane new
			hMatchParent;
			vFitContent.

	postInfoElement := BrHorizontalPane new
			hMatchParent;
			vFitContent;
			visibility: BlVisibility gone.

	headerElement addChild: postInfoElement.

	postInfoElement
		addChild: (profilePicture := GtApFeedUserPictureElement new exact: 12 @ 12);
		addChild: (authorNameLabel := BrLabel new aptitude: BrGlamorousLabelAptitude new);
		addChild: (authorHandleLabel := self buildGrayLabel);
		addChild: (dateLabel := self buildGrayLabel);
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				text: 'wrote').


	parentInfoElement := BrHorizontalPane new
			hMatchParent;
			vFitContent;
			visibility: BlVisibility gone.

	headerElement addChild: parentInfoElement.

	parentInfoElement
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				text: 'Replying to ');
		addChild: (parentProfilePicture := GtApFeedUserPictureElement new exact: 12 @ 12);
		addChild: (parentAuthorNameLabel := BrLabel new aptitude: BrGlamorousLabelAptitude new);
		addChild: (parentAuthorHandleLabel := self buildGrayLabel);
		addChild: (parentDateLabel := self buildGrayLabel).

	^ headerElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> initializeToolbarElement [
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
	
	toolbarElement addItem: self createAddFileButton.

	replyButton := BrButton new
			beTinySize;
			aptitude: BrGlamorousButtonWithLabelAptitude;
			label: 'Reply';
			visibility: BlVisibility gone;
			action: [ :aButton | self onReplyAction: aButton ].

	toolbarElement addItem: replyButton.
	
	deleteButton := BrButton new
			beTinySize;
			aptitude: BrGlamorousButtonWithIconAptitude;
			icon: BrGlamorousVectorIcons cancel;
			label: 'Delete';
			visibility: BlVisibility gone;
			action: [ :aButton | self onDeleteAction: aButton ].

	toolbarElement addItem: deleteButton.

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
							content: [ LeBlueksyAccountSwitcherElement new
									currentlySelected: self snippet client;
									onSelection: [ :aClient | 
										self snippet client: aClient.
										LeBlueskyIdentityStore default addClient: aClient.
										identityElement
											inUIProcessDo: [ identityElement dispatchEvent: BrDropdownHideWish new ] ] ]).

	toolbarElement addItem: identityElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> inputElement [
	^ inputElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> inputElement: anObject [
	inputElement := anObject
]

{ #category : #accessing }
LeBlueskySnippetElement >> onClientChanged [
	(self snippet client isNotNil and: [ self snippet client isLoggedIn ])
		ifTrue: [ identityElement label: self snippet client handle.
			publishButton enable ]
]

{ #category : #accessing }
LeBlueskySnippetElement >> onDeleteAction: aButton [
	self snippet client
		comAtprotoRepoDeleteRecordRepo: self snippet actor atpDid
		collection: AppBskyFeedPostMain atpRecordName
		rkey: (#/ split: (self snippet post at: 'uri')) last
		swapRecord: nil
		swapCommit: nil.
	self snippet post: nil
]

{ #category : #accessing }
LeBlueskySnippetElement >> onPostChanged [
	self updateHeader.
	self snippet hasPost
		ifTrue: [ publishButton visibility: BlVisibility gone.
			addFileButton visibility: BlVisibility gone.
			replyButton visibility: BlVisibility visible.
			deleteButton visibility: BlVisibility visible.
			inputElement beReadOnlyWithSelection ]
		ifFalse: [ publishButton visibility: BlVisibility visible.
			addFileButton visibility: BlVisibility visible.
			replyButton visibility: BlVisibility gone.
			deleteButton visibility: BlVisibility gone.
			inputElement beEditable ]
]

{ #category : #accessing }
LeBlueskySnippetElement >> onPublishAction: aButton [
	| record |
	"self uploadFiles."
	record := {'$type' -> AppBskyFeedPostMain atpRecordName.
			'createdAt' -> DateAndTime now printString.
			'text' -> inputElement text asString} asDictionary.
	"self fileRecords ifNotEmpty: [ record at: 'embed' put: self filesToEmbed ]."

	self snippet hasParentPost
		ifTrue: [ | root |
			root := ((self snippet client
					appBskyFeedGetPostThreadUri: (self snippet parentPost at: 'uri')
					depth: nil) at: 'thread') client: self snippet client.
			record
				at: 'reply'
				put: {'parent' -> self snippet parentPost.
						'root'
							-> {'uri' -> root atpPost atpUri.
									'cid' -> root atpPost atpCid} asDictionary} asDictionary ].

	self snippet
		post: (self snippet client
				comAtprotoRepoCreateRecordRepo: self snippet actor atpDid
				collection: AppBskyFeedPostMain atpRecordName
				rkey: nil
				validate: nil
				record: record
				swapCommit: nil)
]

{ #category : #accessing }
LeBlueskySnippetElement >> onReplyAction: aButton [
	self snippet
		addSnippetAfterSelf: (LeBlueskySnippet empty
				client: self snippet client;
				parentPost: self snippet post).
	self snippet focusNextSnippet
]

{ #category : #accessing }
LeBlueskySnippetElement >> onSnippetViewModelChanged [
	super onSnippetViewModelChanged.
	self onClientChanged.
	self onPostChanged
]

{ #category : #accessing }
LeBlueskySnippetElement >> snippetContent [
	"Return an element that represents a content of the snippet.
	The embedder is responsible for placing #snippetContent in the right place within snippet element depending on the
	View Model properties and derived look"
	<return: #BlElement>

	^ self contentElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> snippetToolbar [
	"Return an element that represents a toolbar of the snippet. A toolbar usually appears below the snippet content.
	The embedder is responsible for placing #snippetToolbar in the right place within snippet element depending on the
	View Model properties and derived look.
	If returned #snippetToolbar is nil, no toolbar will be added"
	<return: #BlElement or: nil>

	^ self toolbarElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> subscribeToSnippetViewModel [
	super subscribeToSnippetViewModel.

	self snippetViewModel
		when: LeBlueskySnippetClientChanged
		send: #onClientChanged
		to: self.
		
	self snippetViewModel
		when: LeBlueskySnippetPostChanged
		send: #onPostChanged
		to: self
]

{ #category : #accessing }
LeBlueskySnippetElement >> toolbarElement [
	<return: #BrToolbar>
	^ toolbarElement
]

{ #category : #accessing }
LeBlueskySnippetElement >> updateFileContainer [
	imageContainer removeChildren.
	imageContainer visibility: BlVisibility visible.
	self files
		do: [ :aFile | 
			imageContainer
				addChild: (BrAsyncFileWidget new
						vExact: 200;
						hExact: 200;
						file: aFile) ]
]

{ #category : #accessing }
LeBlueskySnippetElement >> updateHeader [
	| post |
	self snippet hasPost
		ifTrue: [ postInfoElement visibility: BlVisibility visible.
			post := self snippet atpPost.
			post author
				ifNil: [ authorNameLabel text: '<missing>'.
					authorHandleLabel text: ''.
					^ self ].

			profilePicture user: post author.
			authorNameLabel text: (post author atpDisplayName ifNil: [ '' ]).
			authorHandleLabel text: '@' , post author atpHandle.
			dateLabel text: ' at ' , post createdAtTimestamp printToMinute ]
		ifFalse: [ postInfoElement visibility: BlVisibility gone ].
	self snippet hasParentPost
		ifTrue: [ parentInfoElement visibility: BlVisibility visible.
			post := self snippet atpParent.
			post author
				ifNil: [ parentAuthorNameLabel text: '<missing>'.
					parentAuthorHandleLabel text: ''.
					^ self ].

			parentProfilePicture user: post author.
			parentAuthorNameLabel text: (post author atpDisplayName ifNil: [ '' ]).
			parentAuthorHandleLabel text: '@' , post author atpHandle.
			parentDateLabel text: ' at ' , post createdAtTimestamp printToMinute ]
		ifFalse: [ parentInfoElement visibility: BlVisibility gone ]
]

{ #category : #accessing }
LeBlueskySnippetElement >> uploadFiles [
	self files do: [ :aFile | self fileRecords add: (self snippet client comAtprotoRepoUploadBlobFile: aFile) ]
]
