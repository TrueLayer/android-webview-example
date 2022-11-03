import React from 'react'
import { Linking, SafeAreaView, Text, TextInput, StyleSheet, Button } from 'react-native';
import { WebView } from 'react-native-webview';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen
          name="Home"
          component={HomeScreen}
          options={{ title: 'Redirect Testing' }}
        />
        <Stack.Screen name="WebView" component={WebViewScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}

const HomeScreen = ({ navigation }) => {

  const [url, onChangeUrl] = React.useState("https://payment.truelayer-sandbox.com/test-redirect");

  return (
    <SafeAreaView style={[styles.container]}>
      <Text style={styles.titleText}>
        WebView Example
      </Text>
      <Text style={styles.bodyText}>
        Enter a URL to test app2app redirects
      </Text>
      <TextInput
        style={styles.input}
        value={url}
        onChangeText={onChangeUrl}
        placeholder="URL"
        keyboardType="url"
      />
      <Button
        title="Open in WebView"
        onPress={() =>
          navigation.navigate('WebView', { url: url })
        }
      />
    </SafeAreaView>
  );
};

const WebViewScreen = ({ navigation, route }) => {
  const { url } = route.params;

  handleWebViewNavigationStateChange = (newNavState) => {
    const { url } = newNavState;

    if (!url) return;

    // attempt to redirect to an installed app
    if (!url.includes('payment.truelayer-sandbox.com') && !url.includes('payment.truelayer.com')) {
      Linking.openURL(url).catch(err =>
        console.error('An error occurred', err)
      )    
    }
  };

  return (
    <WebView
      source={{ uri: url }}
      onNavigationStateChange={this.handleWebViewNavigationStateChange}
    />
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 16
  },
  titleText: {
    fontSize: 20,
    marginTop: 16,
    fontWeight: "bold"
  },
  bodyText: {
    fontSize: 16,
    marginTop: 8,
  },
  input: {
    height: 40,
    marginBottom: 8,
    marginTop: 8,
    borderWidth: 1,
    padding: 10,
  },
});

export default App;