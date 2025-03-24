#ifndef __ASSERT_LSL__
#define __ASSERT_LSL__
#define __ASSERT_KO_UNKNOWN__ -1
#define __ASSERT_KO_INEQUAL__ 0
#define __ASSERT_OK__ 1
#define __ASSERT_KO_EMPTY_SOURCE__ 2
#define __ASSERT_KO_EMPTY_EXPECTED__ 3
#define __ASSERT_KO_TYPE_MISMATCH__ 4
#ifndef __ASSERT_MESSAGING__
#define __ASSERT_MESSAGING__
AssertMessaging(string message)
{
    llSay(DEBUG_CHANNEL, message);
}

#endif // __ASSERT_MESSAGING__
/*
    Call back function to prepare output messages
    string testName: The name of the test defined in the calling function
    list actual: boxed value that was returned by the tested function
    list expected: boxed value that was expected by the tested function
    integer result: Enum value for the result of the test
*/
AssertCallback(string testName, list actual, list expected, integer result)
{
    AssertMessaging("Running test '" + testName + "'");
    AssertMessaging("\tExpected '" + llList2String(expected, 0) + "' Actual '" + llList2String(actual, 0) + "'");
    if (result == __ASSERT_KO_EMPTY_EXPECTED__)
    {
        AssertMessaging("\tFAILED. No expected value provided");
    }
    else if (result == __ASSERT_KO_EMPTY_SOURCE__)
    {
        AssertMessaging("\tFAILED. No source value provided");
    }
    else if (result == __ASSERT_OK__)
    {
        AssertMessaging("\tSUCCESS");
    }
    else if (result == __ASSERT_KO_INEQUAL__)
    {
        AssertMessaging("\tFAILED: Values don't match");
    }
    else if (result == __ASSERT_KO_TYPE_MISMATCH__)
    {
        AssertMessaging("\tFAILED: Types mismatch");
    }
    else
    {
        AssertMessaging("\tUNKNOWN ERROR");
    }
}

/*
    Searches 'expected' inside 'src' and checks if the value was fount 'n' times
    string testName: The name of the test defined in the calling function
    list src: The collection to be tested
    list expected: boxed value to be found
    integer n: The amount of time 'expected' should be found
*/
AssertContainsExactlyNTimes(string testName, list src, list expected, integer n)
{
    integer instance = -1;

    while (llListFindListNext(src, expected, ++instance) != -1);
    AssertCallback(testName, [ instance ], [ n ], n == instance);
}

/*
    Checks if 2 values are strictly equal
    string testName: The name of the test defined in the calling function
    list src: boxed value to be tested
    list expected: boxed value to be found
*/
AssertIsEqual(string testName, list src, list expected)
{
    integer result = __ASSERT_KO_UNKNOWN__;
    if (llGetListLength(src) < 1)
    {
        result = __ASSERT_KO_EMPTY_SOURCE__;
    }
    else if (llGetListLength(src) < 1)
    {
        result = __ASSERT_KO_EMPTY_EXPECTED__;
    }
    else
    {
        integer type = llGetListEntryType(src, 0);
        if (type != llGetListEntryType(expected, 0))
        {
            result = __ASSERT_KO_TYPE_MISMATCH__;
        }
        else if (type == TYPE_INTEGER)
        {
            result = llList2Integer(src, 0) == llList2Integer(expected, 0);
        }
        else if (type == TYPE_FLOAT)
        {
            result = llList2Float(src, 0) == llList2Float(expected, 0);
        }
        else if (type == TYPE_STRING)
        {
            result = llList2String(src, 0) == llList2String(expected, 0);
        }
        else if (type == TYPE_KEY)
        {
            result = llList2Key(src, 0) == llList2Key(expected, 0);
        }
        else if (type == TYPE_VECTOR)
        {
            result = llList2Vector(src, 0) == llList2Vector(expected, 0);
        }
        else if (type == TYPE_ROTATION)
        {
            result = llList2Rot(src, 0) == llList2Rot(expected, 0);
        }
    }
    AssertCallback(testName, src, expected, result);
}
#endif // __ASSERT_LSL__
