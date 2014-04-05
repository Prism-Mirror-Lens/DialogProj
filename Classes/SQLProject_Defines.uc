/**
 * \file SQLProject_Defines.uc
 * \brief SQLProject_Defines
 */
//=============================================================================
// Author: Sebastian Schlicht, April 2010
//=============================================================================
/**
 * \class SQLProject_Defines
 * \extends Object
 * \brief SQLProject_Defines
 */
class SQLProject_Defines extends Object;


//=============================================================================
// Functions
//=============================================================================
/**
* Static method to create an empty string object with given length.
* Used in conjunction with DLLBind functions, because memory has to be allocated before assign any data.
* 
* @param aStrLen [int]
* 
* @return string
*/
static function string initString(int aStrLen)
{
	local int il;
	local string aResult;
	for(il=0; il<aStrLen; ++il){
		aResult $= " ";
	}
	return aResult;
}

DefaultProperties
{
}
