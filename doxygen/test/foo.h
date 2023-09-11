#pragma once

namespace foo {

/**
 * @defgroup foo Foo
 * @brief Foo functions.
 */

/** 
 * @ingroup foo
 * @brief Foo function
 * @param[in] f Value to foo.
 * @return \f$f+1\f$
 */
int foo(int f);

/**
 * @ingroup foo
 * @brief Foo function
 * @param[in] f Value to foo.
 * @return \f$f+2\f$
 */
int foo2(int f);

} // namespace foo
