import { AppRegistry } from "react-native";

// Import Products module from Verdaccio - this auto-registers "ModuleProducts"
import "@app/module-products";

// Placeholder registrations for other modules (will be integrated later)
AppRegistry.registerComponent("ModuleCart", () => {
  const { View, Text } = require("react-native");
  return () => (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Cart Module - Coming from Verdaccio</Text>
    </View>
  );
});

AppRegistry.registerComponent("ModulePDP", () => {
  const { View, Text } = require("react-native");
  return () => (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>PDP Module - Coming from Verdaccio</Text>
    </View>
  );
});

