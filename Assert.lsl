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
AssertCallback(string testName, list actual, list expected, integer result)
{
    AssertMessaging("Running test '" + testName + "'");
    AssertMessaging("\tExpected '" + llList2String(expected, 0) + "' Actual '" + llList2String(actual, 0) + "'");
    switch (result)
    {
        case (__ASSERT_KO_EMPTY_EXPECTED__):
        {
            AssertMessaging("\tFAILED. No expected value provided");
            break;
        }
        case (__ASSERT_KO_EMPTY_SOURCE__):
        {
            AssertMessaging("\tFAILED. No source value provided");
            break;
        }
        case (__ASSERT_OK__):
        {
            AssertMessaging("\tSUCCESS");
            break;
        }
        case (__ASSERT_KO_INEQUAL__):
        {
            AssertMessaging("\tFAILED: Values don't match");
            break;
        }
        case (__ASSERT_KO_TYPE_MISMATCH__):
        {
            AssertMessaging("\tFAILED: Types mismatch");
            break;
        }
        default:
        {
            AssertMessaging("\tUNKNOWN ERROR");
        }
    }
}

AssertContainsExactlyNTimes(string testName, list src, list expected, integer n)
{
    integer instance = -1;

    while (llListFindListNext(src, expected, ++instance) != -1);
    AssertCallback(testName, [ instance ], [ n ], n == instance);
}

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
        else
        {
            switch (type)
            {
                case (TYPE_INTEGER):
                {
                    result = llList2Integer(src, 0) == llList2Integer(expected, 0);
                    break;
                }
                case (TYPE_FLOAT):
                {
                    result = llList2Float(src, 0) == llList2Float(expected, 0);
                    break;
                }
                case (TYPE_STRING):
                {
                    result = llList2String(src, 0) == llList2String(expected, 0);
                    break;
                }
                case (TYPE_KEY):
                {
                    result = llList2Key(src, 0) == llList2Key(expected, 0);
                    break;
                }
                case (TYPE_VECTOR):
                {
                    result = llList2Vector(src, 0) == llList2Vector(expected, 0);
                    break;
                }
                case (TYPE_ROTATION):
                {
                    result = llList2Rot(src, 0) == llList2Rot(expected, 0);
                    break;
                }
            }
        }
    }
    AssertCallback(testName, src, expected, result);
}
#endif // __ASSERT_LSL__
