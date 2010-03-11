<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=Content-Type content="text/html; charset=windows-1252"></HEAD>
<BODY><PRE>&lt;%
'--------------------------------------------------------------------
' Microsoft ADO
'
' (c) 1996 Microsoft Corporation.  All Rights Reserved.
'
'
'
' ADO constants include file for VBScript
'
'--------------------------------------------------------------------

'---- CursorTypeEnum Values ----
Const adOpenForwardOnly = 0
Const adOpenKeyset = 1
Const adOpenDynamic = 2
Const adOpenStatic = 3

'---- CursorOptionEnum Values ----
Const adHoldRecords = &amp;H00000100
Const adMovePrevious = &amp;H00000200
Const adAddNew = &amp;H01000400
Const adDelete = &amp;H01000800
Const adUpdate = &amp;H01008000
Const adBookmark = &amp;H00002000
Const adApproxPosition = &amp;H00004000
Const adUpdateBatch = &amp;H00010000
Const adResync = &amp;H00020000
Const adNotify = &amp;H00040000

'---- LockTypeEnum Values ----
Const adLockReadOnly = 1
Const adLockPessimistic = 2
Const adLockOptimistic = 3
Const adLockBatchOptimistic = 4

'---- ExecuteOptionEnum Values ----
Const adRunAsync = &amp;H00000010

'---- ObjectStateEnum Values ----
Const adStateClosed = &amp;H00000000
Const adStateOpen = &amp;H00000001
Const adStateConnecting = &amp;H00000002
Const adStateExecuting = &amp;H00000004

'---- CursorLocationEnum Values ----
Const adUseServer = 2
Const adUseClient = 3

'---- DataTypeEnum Values ----
Const adEmpty = 0
Const adTinyInt = 16
Const adSmallInt = 2
Const adInteger = 3
Const adBigInt = 20
Const adUnsignedTinyInt = 17
Const adUnsignedSmallInt = 18
Const adUnsignedInt = 19
Const adUnsignedBigInt = 21
Const adSingle = 4
Const adDouble = 5
Const adCurrency = 6
Const adDecimal = 14
Const adNumeric = 131
Const adBoolean = 11
Const adError = 10
Const adUserDefined = 132
Const adVariant = 12
Const adIDispatch = 9
Const adIUnknown = 13
Const adGUID = 72
Const adDate = 7
Const adDBDate = 133
Const adDBTime = 134
Const adDBTimeStamp = 135
Const adBSTR = 8
Const adChar = 129
Const adVarChar = 200
Const adLongVarChar = 201
Const adWChar = 130
Const adVarWChar = 202
Const adLongVarWChar = 203
Const adBinary = 128
Const adVarBinary = 204
Const adLongVarBinary = 205

'---- FieldAttributeEnum Values ----
Const adFldMayDefer = &amp;H00000002
Const adFldUpdatable = &amp;H00000004
Const adFldUnknownUpdatable = &amp;H00000008
Const adFldFixed = &amp;H00000010
Const adFldIsNullable = &amp;H00000020
Const adFldMayBeNull = &amp;H00000040
Const adFldLong = &amp;H00000080
Const adFldRowID = &amp;H00000100
Const adFldRowVersion = &amp;H00000200
Const adFldCacheDeferred = &amp;H00001000

'---- EditModeEnum Values ----
Const adEditNone = &amp;H0000
Const adEditInProgress = &amp;H0001
Const adEditAdd = &amp;H0002
Const adEditDelete = &amp;H0004

'---- RecordStatusEnum Values ----
Const adRecOK = &amp;H0000000
Const adRecNew = &amp;H0000001
Const adRecModified = &amp;H0000002
Const adRecDeleted = &amp;H0000004
Const adRecUnmodified = &amp;H0000008
Const adRecInvalid = &amp;H0000010
Const adRecMultipleChanges = &amp;H0000040
Const adRecPendingChanges = &amp;H0000080
Const adRecCanceled = &amp;H0000100
Const adRecCantRelease = &amp;H0000400
Const adRecConcurrencyViolation = &amp;H0000800
Const adRecIntegrityViolation = &amp;H0001000
Const adRecMaxChangesExceeded = &amp;H0002000
Const adRecObjectOpen = &amp;H0004000
Const adRecOutOfMemory = &amp;H0008000
Const adRecPermissionDenied = &amp;H0010000
Const adRecSchemaViolation = &amp;H0020000
Const adRecDBDeleted = &amp;H0040000

'---- GetRowsOptionEnum Values ----
Const adGetRowsRest = -1

'---- PositionEnum Values ----
Const adPosUnknown = -1
Const adPosBOF = -2
Const adPosEOF = -3

'---- enum Values ----
Const adBookmarkCurrent = 0
Const adBookmarkFirst = 1
Const adBookmarkLast = 2

'---- MarshalOptionsEnum Values ----
Const adMarshalAll = 0
Const adMarshalModifiedOnly = 1

'---- AffectEnum Values ----
Const adAffectCurrent = 1
Const adAffectGroup = 2
Const adAffectAll = 3

'---- FilterGroupEnum Values ----
Const adFilterNone = 0
Const adFilterPendingRecords = 1
Const adFilterAffectedRecords = 2
Const adFilterFetchedRecords = 3
Const adFilterPredicate = 4

'---- SearchDirection Values ----
Const adSearchForward = 1
Const adSearchBackward = -1

'---- ConnectPromptEnum Values ----
Const adPromptAlways = 1
Const adPromptComplete = 2
Const adPromptCompleteRequired = 3
Const adPromptNever = 4

'---- ConnectModeEnum Values ----
Const adModeUnknown = 0
Const adModeRead = 1
Const adModeWrite = 2
Const adModeReadWrite = 3
Const adModeShareDenyRead = 4
Const adModeShareDenyWrite = 8
Const adModeShareExclusive = &amp;Hc
Const adModeShareDenyNone = &amp;H10

'---- IsolationLevelEnum Values ----
Const adXactUnspecified = &amp;Hffffffff
Const adXactChaos = &amp;H00000010
Const adXactReadUncommitted = &amp;H00000100
Const adXactBrowse = &amp;H00000100
Const adXactCursorStability = &amp;H00001000
Const adXactReadCommitted = &amp;H00001000
Const adXactRepeatableRead = &amp;H00010000
Const adXactSerializable = &amp;H00100000
Const adXactIsolated = &amp;H00100000

'---- XactAttributeEnum Values ----
Const adXactCommitRetaining = &amp;H00020000
Const adXactAbortRetaining = &amp;H00040000

'---- PropertyAttributesEnum Values ----
Const adPropNotSupported = &amp;H0000
Const adPropRequired = &amp;H0001
Const adPropOptional = &amp;H0002
Const adPropRead = &amp;H0200
Const adPropWrite = &amp;H0400

'---- ErrorValueEnum Values ----
Const adErrInvalidArgument = &amp;Hbb9
Const adErrNoCurrentRecord = &amp;Hbcd
Const adErrIllegalOperation = &amp;Hc93
Const adErrInTransaction = &amp;Hcae
Const adErrFeatureNotAvailable = &amp;Hcb3
Const adErrItemNotFound = &amp;Hcc1
Const adErrObjectInCollection = &amp;Hd27
Const adErrObjectNotSet = &amp;Hd5c
Const adErrDataConversion = &amp;Hd5d
Const adErrObjectClosed = &amp;He78
Const adErrObjectOpen = &amp;He79
Const adErrProviderNotFound = &amp;He7a
Const adErrBoundToCommand = &amp;He7b
Const adErrInvalidParamInfo = &amp;He7c
Const adErrInvalidConnection = &amp;He7d
Const adErrStillExecuting = &amp;He7f
Const adErrStillConnecting = &amp;He81

'---- ParameterAttributesEnum Values ----
Const adParamSigned = &amp;H0010
Const adParamNullable = &amp;H0040
Const adParamLong = &amp;H0080

'---- ParameterDirectionEnum Values ----
Const adParamUnknown = &amp;H0000
Const adParamInput = &amp;H0001
Const adParamOutput = &amp;H0002
Const adParamInputOutput = &amp;H0003
Const adParamReturnValue = &amp;H0004

'---- CommandTypeEnum Values ----
Const adCmdUnknown = &amp;H0008
Const adCmdText = &amp;H0001
Const adCmdTable = &amp;H0002
Const adCmdStoredProc = &amp;H0004

'---- SchemaEnum Values ----
Const adSchemaProviderSpecific = -1
Const adSchemaAsserts = 0
Const adSchemaCatalogs = 1
Const adSchemaCharacterSets = 2
Const adSchemaCollations = 3
Const adSchemaColumns = 4
Const adSchemaCheckConstraints = 5
Const adSchemaConstraintColumnUsage = 6
Const adSchemaConstraintTableUsage = 7
Const adSchemaKeyColumnUsage = 8
Const adSchemaReferentialContraints = 9
Const adSchemaTableConstraints = 10
Const adSchemaColumnsDomainUsage = 11
Const adSchemaIndexes = 12
Const adSchemaColumnPrivileges = 13
Const adSchemaTablePrivileges = 14
Const adSchemaUsagePrivileges = 15
Const adSchemaProcedures = 16
Const adSchemaSchemata = 17
Const adSchemaSQLLanguages = 18
Const adSchemaStatistics = 19
Const adSchemaTables = 20
Const adSchemaTranslations = 21
Const adSchemaProviderTypes = 22
Const adSchemaViews = 23
Const adSchemaViewColumnUsage = 24
Const adSchemaViewTableUsage = 25
Const adSchemaProcedureParameters = 26
Const adSchemaForeignKeys = 27
Const adSchemaPrimaryKeys = 28
Const adSchemaProcedureColumns = 29
%&gt;
</PRE></BODY></HTML>
