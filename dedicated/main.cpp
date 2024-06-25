#include <clang-c/Index.h>
#include <iostream>
#include <string>
#include <vector>

// Function to print diagnostic information
void printDiagnostics(CXTranslationUnit translationUnit) {
    int numDiagnostics = clang_getNumDiagnostics(translationUnit);
    for (int i = 0; i < numDiagnostics; ++i) {
        CXDiagnostic diagnostic = clang_getDiagnostic(translationUnit, i);
        CXString diagnosticSpelling = clang_formatDiagnostic(diagnostic, clang_defaultDiagnosticDisplayOptions());
        std::cerr << clang_getCString(diagnosticSpelling) << std::endl;
        clang_disposeString(diagnosticSpelling);
        clang_disposeDiagnostic(diagnostic);
    }
}

int main() {
    // Sample C++ code
    std::string code = R"(
        #include <iostream>
        int main() {
            std::cout << "Hello, World!" << std::endl;
            return 0;
        }
    )";

    // Initialize the index
    CXIndex index = clang_createIndex(0, 0);

    // Create unsaved file
    CXUnsavedFile unsavedFile;
    unsavedFile.Filename = "example.cpp";
    unsavedFile.Contents = code.c_str();
    unsavedFile.Length = code.size();

    // Parse the translation unit
    CXTranslationUnit translationUnit = clang_parseTranslationUnit(
        index,
        "example.cpp",
        nullptr, 0,
        &unsavedFile, 1,
        CXTranslationUnit_None
    );

    if (translationUnit == nullptr) {
        std::cerr << "Unable to parse translation unit." << std::endl;
        return 1;
    }

    // Print diagnostics
    printDiagnostics(translationUnit);

    // Clean up
    clang_disposeTranslationUnit(translationUnit);
    clang_disposeIndex(index);

    return 0;
}