/**
 * UDK Database database manager.
 * Used to initialize and set up all game databases.
 * Used to save and load savegame databases.
 */
class SQLProject_DatabaseMgr extends Object
	dependson(SQLProject_DLLAPI)
	config(Database);


//=============================================================================
// Variables
//=============================================================================
var private SQLProject_DLLAPI mDLLAPI;
var private GameInfo mGameInfo;

var config ESQLDriver mDatabaseDriver;
var config string mUserCodeRelPathUDKGame;
var config string mDataRootPath;

var config array<string> mDefaultContentDBs;
var config string mDefaultGameplayDB;

var config string mDefaultDialogueDB;

var int mGameplayDatabaseIdx;
var int mDialogueDatabaseIdx;


//=============================================================================
// Functions
//=============================================================================
/**
 * Get the created DLLAPI object to gain access of all the API functions.
 * 
 * \return Allocated DLLAPI object
*/
final function SQLProject_DLLAPI getDLLAPI()
{
	return mDLLAPI;
}

/**
 * Initialise the databasedriver and creat/load the default databases
 * 
*/
function initDatabase(GameInfo aGameInfo)
{
	mGameInfo = aGameInfo;
	mDLLAPI.SQL_initSQLDriver(mDatabaseDriver); // automatically create one empty DB

	loadGameplayDatabase();
	loadDialogueDatabase();
	//createGameplayDatabase();
}

/**
 * Load all per default properties set game content databases into memory
*/
final function loadGameContentDatabases()
{
	local int il;
	local int lNewDatabase;
	local string lFilePath;

	if(mDefaultContentDBs.Length > 0){
		lFilePath = mUserCodeRelPathUDKGame $ mDataRootPath;

		if(mDLLAPI.SQL_loadDatabase(lFilePath $ mDefaultContentDBs[0])){
			`log("<<< GameContentDatabase loaded: " $ lFilePath $ mDefaultContentDBs[0]);
		}

		for(il=1; il<mDefaultContentDBs.Length; ++il){
			lNewDatabase = mDLLAPI.SQL_createDatabase();
			if(lNewDatabase >= 0){
				mDLLAPI.SQL_selectDatabase(lNewDatabase);
				if(mDLLAPI.SQL_loadDatabase(lFilePath $ mDefaultContentDBs[il])){
					`log("<<< GameContentDatabase loaded: " $ lFilePath $ mDefaultContentDBs[il]);
				}
				if(mDLLAPI.SQL_initGameplayValues(lNewDatabase)) {
					`log("<<< GameContent initalised");
				}
			}
		}
		mGameplayDatabaseIdx = lNewDatabase;
	}
}

/**
 * Create the default database for gamplay and load the basic database structure into memory.
*/
function createGameplayDatabase()
{
	local int lNewDatabase;
	local string lFilePath;

	lNewDatabase = mDLLAPI.SQL_createDatabase();
	if(lNewDatabase >= 0 && mDefaultGameplayDB != ""){
		lFilePath = mUserCodeRelPathUDKGame $ mDataRootPath;
		mDLLAPI.SQL_selectDatabase(lNewDatabase);
		if(mDLLAPI.SQL_loadDatabase(lFilePath $ mDefaultGameplayDB)){
			`log("<<< GameplayTemplate loaded: " $ lFilePath $ mDefaultGameplayDB);
		}
		mGameplayDatabaseIdx = lNewDatabase;
	}
}

function loadGameplayDatabase()
{
	local string lFilePath;
	local int lNewDatabase;
	local int avalue;

	avalue = 12;

	lFilePath = mUserCodeRelPathUDKGame $ mDataRootPath;
	lNewDatabase = mDLLAPI.SQL_createDatabase();
	mDLLAPI.SQL_selectDatabase(lNewDatabase);

		if(mDLLAPI.SQL_loadDatabase(lFilePath $ mDefaultGameplayDB)){
			`log("<<< Gameplay DB loaded: " $ lFilePath $ mDefaultGameplayDB);
			if(mDLLAPI.SQL_initGameplayValues(lNewDatabase)){
				
				`log("<<< Gameplay values initialised");
			}
			else
			{
				`log("something bad happened");
			}
			mDLLAPI.SQL_testGameplayValues(avalue);
			`log("<<< STRENGTH"$avalue);

		}
		mGameplayDatabaseIdx = lNewDatabase;
}

function loadDialogueDatabase()
{
	local string lFilePath;
	local int lNewDatabase;

	lFilePath = mUserCodeRelPathUDKGame $ mDataRootPath;
	lNewDatabase = mDLLAPI.SQL_createDatabase();
	mDLLAPI.SQL_selectDatabase(lNewDatabase);

		if(mDLLAPI.SQL_loadDatabase(lFilePath $ mDefaultDialogueDB)){
			`log("<<< DialogueDatabase loaded: " $ lFilePath $ mDefaultDialogueDB);
		}
		mDialogueDatabaseIdx = lNewDatabase;
}

DefaultProperties
{
	Begin Object Class=SQLProject_DLLAPI Name=DllApiInstance
	End Object
	mDLLAPI=DllApiInstance

}
