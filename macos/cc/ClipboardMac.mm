#include <jni.h>
#include <AppKit/NSPasteboard.h>
#import <Foundation/Foundation.h>
#include "ClipboardMac.hh"
#include <StringUTF16.hh>
#include <impl/Library.hh>
#include <impl/JNILocal.hh>
#include <cstring>

extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_Clipboard__1nSet
        (JNIEnv *env, jclass jclass, jobjectArray entries) {
    NSLog(@"Clipboard.set");

    using namespace jwm;

    jsize size = env->GetArrayLength(entries);
    for (jsize i = 0; i < size; ++i) {
        jobject entry = env->GetObjectArrayElement(entries, i);

        if (entry) {
            jobject format = classes::ClipboardEntry::getFormat(env, entry);
            jbyteArray data = classes::ClipboardEntry::getData(env, entry);
            jsize dataSize = env->GetArrayLength(data);

            StringUTF16 formatId = StringUTF16::makeFromJString(env, classes::ClipboardFormat::getFormatId(env, format));
            std::string formatStdStr = formatId.toAscii();

            if (formatStdStr == "text/plain") {
              NSData* nsData;
              {
                  jbyte* dataBytes = env->GetByteArrayElements(data, nullptr);
                  nsData = [NSData dataWithBytes:dataBytes length:dataSize];
                  env->ReleaseByteArrayElements(data, dataBytes, JNI_ABORT);
              }

              NSPasteboard* board = [NSPasteboard generalPasteboard];

              [board declareTypes:[NSArray arrayWithObject:NSPasteboardTypeString] owner:nil];

              BOOL ret = [[NSPasteboard generalPasteboard] setData:nsData forType:NSPasteboardTypeString];

              NSLog(@"setString ret = %d", ret);
            } else {
              NSLog(@"setData not implemented for %s", formatStdStr.c_str());
            }
        }
    }
}

extern "C" JNIEXPORT jobject JNICALL Java_io_github_humbleui_jwm_Clipboard__1nGet
        (JNIEnv *env, jclass jclass, jobjectArray formats) {
    printf("get\n");
    return nullptr;
}

extern "C" JNIEXPORT jobjectArray JNICALL Java_io_github_humbleui_jwm_Clipboard__1nGetFormats
        (JNIEnv *env, jclass jclass) {
    printf("getFormats\n");
    return nullptr;
}

extern "C" JNIEXPORT void JNICALL Java_io_github_humbleui_jwm_Clipboard__1nClear(JNIEnv *env, jclass jclass) {
    NSPasteboard* board = [NSPasteboard generalPasteboard];
    [board clearContents];
}

extern "C" JNIEXPORT jboolean JNICALL Java_io_github_humbleui_jwm_Clipboard__1nRegisterFormat
        (JNIEnv *env, jclass jclass, jstring formatId) {
    printf("registerFormat\n");
    return true;
}
