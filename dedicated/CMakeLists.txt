cmake_minimum_required(VERSION 3.10)

# Project name
project(CompileString)

# Find LLVM package
find_package(LLVM REQUIRED CONFIG)
find_package(Clang REQUIRED CONFIG)




# Include LLVM headers
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# Create an executable from the source file
add_executable(compile_string main.cpp)



# Link the LLVM and Clang libraries to the executable
llvm_map_components_to_libnames(llvm_libs
    support
    core
    irreader
    frontendopenmp
    analysis
    codegen
    coverage
    #debuginfooption
    #disassembler
    executionengine
    instrumentation
    interpreter
    linker
    lto
    mc
    mcdisassembler
    mcjit
    objcarcopts
    object
    option
    passes
    profiledata
    runtimedyld
    scalaropts
    target
    transformutils
    vectorize
    WebAssemblyAsmParser
    WebAssemblyCodeGen  # Adjusted for WebAssembly codegen
)

target_link_libraries(compile_string ${llvm_libs} ${CLANG_LIBRARY}
    clangAST
    clangBasic
    clangFrontend
    clangDriver
    clangSerialization
    clangParse
    clangSema
    clangEdit
    clangAnalysis
    clangRewriteFrontend
    clangRewrite
    clangASTMatchers
    clangStaticAnalyzerFrontend
    clangStaticAnalyzerCheckers
    clangStaticAnalyzerCore
)

# add linker options -s ERROR_ON_UNDEFINED_SYMBOLS=0

target_link_options(compile_string PRIVATE -s ERROR_ON_UNDEFINED_SYMBOLS=0  -sASSERTIONS)
target_compile_options(compile_string PRIVATE -s ERROR_ON_UNDEFINED_SYMBOLS=0  -sASSERTIONS)

# ensure debug mode
set(CMAKE_BUILD_TYPE Debug)