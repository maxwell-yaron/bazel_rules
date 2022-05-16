load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def cppcheck_deps():
  http_archive(                            
    name = "cppcheck",                   
    urls = [                             
        "https://github.com/danmar/cppcheck/archive/refs/tags/2.7.zip",                    
    ],                                   
    sha256 = "9285bf64af22a07fb24a7431510cc34fba118cf6950190abc2a08c9f7a7084c8",
    strip_prefix = "cppcheck-2.7",                
    build_file = "@bazel_rules//:cppcheck/cppcheck.bazel",
  )

def gtest_deps():
  http_archive(                            
      name = "gtest",                      
      urls = [                             
          "https://github.com/google/googletest/archive/refs/tags/release-1.11.0.tar.gz",    
      ],                                   
      sha256 = "b4870bf121ff7795ba20d20bcdd8627b8e088f2d1dab299a031c1034eddc93d5",           
      strip_prefix = "googletest-release-1.11.0",
  )                                        
