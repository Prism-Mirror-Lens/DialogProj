/**
 * \file SQLProject_DLLAPI.uc
 * \brief SQLProject_DLLAPI
 */
//=============================================================================
// Author: Sebastian Schlicht, April 2010
//=============================================================================
/**
 * \class SQLProject_DLLAPI
 * \extends Object
 * \brief SQLProject_DLLAPI
 */
class SQLProject_DLLAPI extends Object
	DLLBind(UDKProjectDLL);


//=============================================================================
// Enumeration & Structs
//=============================================================================
/**
 * Enumeration for several SQL Drivers added to UDKProjectDLL
 */
enum ESQLDriver
{
	SQLDrv_Invalid, /*!< */
	SQLDrv_SQLite, /*!< */
};

//=============================================================================
// DLLBind Functions
//=============================================================================
dllimport final function SQL_initSQLDriver(int aSQLDriver);
dllimport final function int SQL_createDatabase();
dllimport final function SQL_closeDatabase(int aDbIdx);
dllimport final function bool SQL_selectDatabase(int aDbIdx);
dllimport final function bool SQL_loadDatabase(string aFilename);
dllimport final function bool SQL_initGameplayValues(int gameplayIndex);
dllimport final function SQL_testGameplayValues(out int value);
dllimport final function bool SQL_saveDatabase(string aFilename);
dllimport final function bool SQL_queryDatabase(string aStatement);
dllimport final function SQL_prepareStatement(string aStatement);
dllimport final function bool SQL_bindValueInt(int aParamIndex, int aValue);
dllimport final function bool SQL_bindNamedValueInt(string aParamName, int aValue);
dllimport final function bool SQL_bindValueFloat(int aParamIndex, float aValue);
dllimport final function bool SQL_bindNamedValueFloat(string aParamName, float aValue);
dllimport final function bool SQL_bindValueString(int aParamIndex, string aValue);
dllimport final function bool SQL_bindNamedValueString(string aParamName, string aValue);
dllimport final function bool SQL_executeStatement();
dllimport final function bool SQL_nextResult();
dllimport final function int SQL_lastInsertID();
dllimport final function SQL_getIntVal(string aParamName, out int aValue);
dllimport final function SQL_getFloatVal(string aParamName, out float aValue);
dllimport final function SQL_getStringVal(string aParamName, out string aValue);

// DEPRECATED
dllimport final function SQL_getValueInt(int aColumnIdx, out int aValue);
dllimport final function SQL_getValueFloat(int aColumnIdx, out float aValue);
dllimport final function SQL_getValueString(int aColumnIdx, out string aValue);

dllimport final function bool IO_directoryExists(string aDirectoryPath);
dllimport final function bool IO_createDirectory(string aDirectoryPath);
dllimport final function bool IO_deleteDirectory(string aDirectoryPath, int aRecursive);
dllimport final function bool IO_fileExists(string aFilePath);
dllimport final function bool IO_deleteFile(string aFilePath);

//EVAL FUNCTIONS
dllimport final function bool evaluate(string condition);
dllimport final function processBody(string body, out string aValue);
dllimport final function updateSymbol(string symbol, float newValue, int dbIndex);
dllimport final function updateToken(string token, string newValue, int dbIndex);

DefaultProperties
{
}
