const path = require("path");
const { getDefaultConfig, mergeConfig } = require("@react-native/metro-config");

const projectRoot = __dirname;
const nodeModules = path.join(projectRoot, "node_modules");

const defaultConfig = getDefaultConfig(projectRoot);

module.exports = mergeConfig(defaultConfig, {
  resolver: {
    // Ensure Metro can resolve scoped packages (@app, @pkg)
    nodeModulesPaths: [nodeModules],
    // Enable source maps for better debugging
    sourceExts: [...(defaultConfig.resolver?.sourceExts || []), "jsx", "js", "ts", "tsx"],
  },
  watchFolders: [nodeModules],
  // Clear Metro cache if having resolution issues
  resetCache: false,
});

