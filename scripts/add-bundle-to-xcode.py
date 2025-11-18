#!/usr/bin/env python3
"""
Script to automatically add main.jsbundle to Xcode project's Copy Bundle Resources.
This modifies the project.pbxproj file directly.
"""
import os
import re
import sys
import uuid

def generate_uuid():
    """Generate a 24-character hex UUID for Xcode project files"""
    return uuid.uuid4().hex[:24].upper()

def add_bundle_to_xcode_project(project_path, bundle_path):
    """Add main.jsbundle to Xcode project's Copy Bundle Resources build phase"""
    
    if not os.path.exists(project_path):
        print(f"❌ Xcode project not found: {project_path}")
        return False
    
    if not os.path.exists(bundle_path):
        print(f"❌ Bundle file not found: {bundle_path}")
        print("   Run: cd js && npm run bundle")
        return False
    
    # Read the project file
    with open(project_path, 'r') as f:
        content = f.read()
    
    # Get relative path from project to bundle
    project_dir = os.path.dirname(project_path)
    bundle_rel_path = os.path.relpath(bundle_path, project_dir)
    
    # Check if bundle is already in the project
    if bundle_rel_path in content or 'main.jsbundle' in content:
        # Check if it's in Copy Bundle Resources
        if 'main.jsbundle' in content and 'PBXResourcesBuildPhase' in content:
            # Try to find if it's already in resources
            resources_section = re.search(r'PBXResourcesBuildPhase section = \{[^}]*\};', content, re.DOTALL)
            if resources_section and 'main.jsbundle' in resources_section.group():
                print("✅ main.jsbundle is already in Copy Bundle Resources")
                return True
    
    # Generate UUIDs for the file reference and build file
    file_ref_uuid = generate_uuid()
    build_file_uuid = generate_uuid()
    
    # Find the main group (usually the first PBXGroup)
    main_group_match = re.search(r'/\* NativeIOSApp \*/ = \{[^}]*isa = PBXGroup[^}]*children = \(([^)]+)\)', content)
    if not main_group_match:
        print("❌ Could not find main group in Xcode project")
        return False
    
    # Check if file reference already exists
    if f'main.jsbundle' in content:
        # Extract existing file reference UUID
        existing_ref = re.search(r'([A-F0-9]{24}) /\* main\.jsbundle \*/', content)
        if existing_ref:
            file_ref_uuid = existing_ref.group(1)
            print(f"✅ Found existing file reference: {file_ref_uuid}")
    else:
        # Add file reference to main group
        children = main_group_match.group(1)
        new_child = f'\n\t\t\t\t{file_ref_uuid} /* main.jsbundle */,'
        if new_child not in children:
            content = content.replace(
                main_group_match.group(0),
                main_group_match.group(0).replace(
                    f'children = ({children})',
                    f'children = ({children}{new_child}\n\t\t\t)'
                )
            )
            print(f"✅ Added file reference to main group: {file_ref_uuid}")
    
    # Add file reference section
    file_ref_section = f'\n\t\t{file_ref_uuid} /* main.jsbundle */ = {{isa = PBXFileReference; lastKnownFileType = text; path = "main.jsbundle"; sourceTree = "<group>"; }};'
    if file_ref_section not in content:
        # Find where to insert (after other file references)
        file_refs_match = re.search(r'(/\* Begin PBXFileReference section \*/)', content)
        if file_refs_match:
            insert_pos = file_refs_match.end()
            content = content[:insert_pos] + file_ref_section + content[insert_pos:]
            print(f"✅ Added file reference section: {file_ref_uuid}")
    
    # Find Copy Bundle Resources build phase
    resources_phase_match = re.search(r'(/\* Resources \*/ = \{[^}]*isa = PBXResourcesBuildPhase[^}]*files = \()([^)]*)(\);)', content, re.DOTALL)
    if resources_phase_match:
        files_section = resources_phase_match.group(2)
        build_file_entry = f'\n\t\t\t\t{build_file_uuid} /* main.jsbundle in Resources */,'
        
        if build_file_entry not in files_section:
            # Add build file entry
            content = content.replace(
                resources_phase_match.group(0),
                resources_phase_match.group(1) + files_section + build_file_entry + '\n\t\t\t' + resources_phase_match.group(3)
            )
            print(f"✅ Added to Copy Bundle Resources: {build_file_uuid}")
        else:
            print("✅ Already in Copy Bundle Resources")
    else:
        print("⚠️  Could not find Copy Bundle Resources build phase")
        print("   You may need to add it manually in Xcode")
        return False
    
    # Add build file section
    build_file_section = f'\n\t\t{build_file_uuid} /* main.jsbundle in Resources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* main.jsbundle */; }};'
    if build_file_section not in content:
        build_files_match = re.search(r'(/\* Begin PBXBuildFile section \*/)', content)
        if build_files_match:
            insert_pos = build_files_match.end()
            content = content[:insert_pos] + build_file_section + content[insert_pos:]
            print(f"✅ Added build file section: {build_file_uuid}")
    
    # Write back to file
    with open(project_path, 'w') as f:
        f.write(content)
    
    print("✅ Successfully added main.jsbundle to Xcode project!")
    return True

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    project_path = os.path.join(project_root, 'ios', 'NativeIOSApp', 'NativeIOSApp.xcodeproj', 'project.pbxproj')
    bundle_path = os.path.join(project_root, 'ios', 'NativeIOSApp', 'NativeIOSApp', 'main.jsbundle')
    
    print("🔧 Adding main.jsbundle to Xcode project...")
    print(f"   Project: {project_path}")
    print(f"   Bundle: {bundle_path}")
    print()
    
    success = add_bundle_to_xcode_project(project_path, bundle_path)
    
    if success:
        print()
        print("✅ Done! The bundle is now included in the Xcode project.")
        print("   Rebuild the app in Xcode to use the bundled JavaScript.")
    else:
        print()
        print("❌ Failed to add bundle automatically.")
        print("   Please add it manually in Xcode:")
        print("   1. Right-click 'NativeIOSApp' folder → 'Add Files to NativeIOSApp...'")
        print("   2. Select 'main.jsbundle'")
        print("   3. UNCHECK 'Copy items if needed'")
        print("   4. CHECK 'Create groups' and 'NativeIOSApp' target")
        sys.exit(1)

