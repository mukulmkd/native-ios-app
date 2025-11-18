#!/bin/bash

# Fix missing headers in HermesExecutorFactory.cpp
HERMES_FILE="../js/node_modules/react-native/ReactCommon/hermes/executor/HermesExecutorFactory.cpp"

if [ -f "$HERMES_FILE" ]; then
  # Check if headers are already added
  if ! grep -q "#include <thread>" "$HERMES_FILE"; then
    # Add headers after jsinspector-modern include
    sed -i '' '/#include <jsinspector-modern\/InspectorFlags.h>/a\
#include <thread>\
#include <atomic>
' "$HERMES_FILE"
    echo "✅ Fixed HermesExecutorFactory.cpp headers"
  else
    echo "✅ Headers already fixed"
  fi
else
  echo "⚠️  HermesExecutorFactory.cpp not found (this is OK if Hermes is disabled)"
fi

