load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def ceres_solver_deps():
  http_archive(
      name = "ceres_solver",
      urls = [
          "https://github.com/ceres-solver/ceres-solver/archive/refs/tags/2.1.0.zip",
      ],
      build_file = "@bazel_rules//:ceres_solver/ceres_solver.bazel",
      sha256 = "57149e2018f3cf3fe97bc1df4a36f33319800b3f752ec1d01b28788d21cd496e",
      strip_prefix = "ceres-solver-2.1.0",                
  )

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

def gflags_deps():
  http_archive(
    name = "gflags",
    sha256 = "6e16c8bc91b1310a44f3965e616383dbda48f83e8c1eaa2370a215057b00cabe",
    strip_prefix = "gflags-77592648e3f3be87d6c7123eb81cbad75f9aef5a",
    urls = [
        "https://mirror.bazel.build/github.com/gflags/gflags/archive/77592648e3f3be87d6c7123eb81cbad75f9aef5a.tar.gz",
        "https://github.com/gflags/gflags/archive/77592648e3f3be87d6c7123eb81cbad75f9aef5a.tar.gz",
    ],
  )

def glog_deps():
  http_archive(
    name = "glog",
    sha256 = "2e0ac963a68216855ce4d1d8cc5e2226254e0e6bc4d70fd2fa0300c6fa0fefef",
    strip_prefix = "glog-8d7a107d68c127f3f494bb7807b796c8c5a97a82",
    urls = [
     "https://github.com/google/glog/archive/8d7a107d68c127f3f494bb7807b796c8c5a97a82.tar.gz"
    ],
    repo_mapping = {
        "@com_github_gflags_gflags": "@gflags"
    },
  )

def doxygen_awesome_deps():
  http_archive(
      name = "doxygen_awesome",
      urls = [
          "https://github.com/jothepro/doxygen-awesome-css/archive/refs/tags/v2.2.1.tar.gz",
      ],
      sha256="c21f3992ea9da52c91b421db8dd9f2a08596150a7e6cf427e5e62d87803feef9",
      build_file = "@bazel_rules//:doxygen_awesome/doxygen_awesome.bazel",
      strip_prefix = "doxygen-awesome-css-2.2.1",
  )

def eigen_deps():
  http_archive(
      name = "eigen",
      urls = [
          "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip",
      ],
      sha256 = "1ccaabbfe870f60af3d6a519c53e09f3dcf630207321dffa553564a8e75c4fc8",
      build_file = "@bazel_rules//:eigen/eigen.bazel",
      strip_prefix = "eigen-3.4.0",
  )

def sophus_deps():
  http_archive(
      name = "sophus",
      urls = [
          "https://github.com/strasdat/Sophus/archive/refs/tags/v22.04.1.zip",
      ],
      sha256 = "60d1d6c81426af8f330960002fb351db06e595501274310ddbe7bfc0aacda97a",
      build_file = "@bazel_rules//:sophus/sophus.bazel",
      strip_prefix = "Sophus-22.04.1",
  )

def nanoflann_deps():
  http_archive(
      name = "nanoflann",
      urls = [
          "https://github.com/jlblancoc/nanoflann/archive/refs/tags/v1.4.2.zip",
      ],
      sha256 = "e4fe8b7615fa5e62d68ba33ff95cadd7e520de44f61e23e44210132d88261f0b",
      build_file = "@bazel_rules//:nanoflann/nanoflann.bazel",
      strip_prefix = "nanoflann-1.4.2",
  )

