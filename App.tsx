/**
 * Buton Sayaç Uygulaması
 * @format
 */

import React, { useState } from 'react';
import {
  SafeAreaView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  StatusBar,
  useColorScheme,
} from 'react-native';

function App() {
  const [count, setCount] = useState(0);
  const isDarkMode = useColorScheme() === 'dark';

  const increment = () => setCount(count + 1);
  const decrement = () => setCount(count - 1);
  const reset = () => setCount(0);

  const backgroundStyle = {
    backgroundColor: isDarkMode ? '#1a1a1a' : '#f5f5f5',
    flex: 1,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <View style={styles.container}>
        <Text style={[styles.title, isDarkMode && styles.titleDark]}>
          KTS Besmelematik
        </Text>
        
        <View style={styles.counterContainer}>
          <Text style={[styles.counterText, isDarkMode && styles.counterTextDark]}>
            {count}
          </Text>
        </View>

        <View style={styles.buttonContainer}>
          <TouchableOpacity
            style={[styles.button, styles.buttonIncrement]}
            onPress={increment}>
            <Text style={styles.buttonText}>+ Arttır</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.button, styles.buttonDecrement]}
            onPress={decrement}>
            <Text style={styles.buttonText}>- Azalt</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.button, styles.buttonReset]}
            onPress={reset}>
            <Text style={styles.buttonText}>↻ Sıfırla</Text>
          </TouchableOpacity>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 50,
    color: '#333',
  },
  titleDark: {
    color: '#fff',
  },
  counterContainer: {
    width: 200,
    height: 200,
    borderRadius: 100,
    backgroundColor: '#fff',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 50,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 4,
    },
    shadowOpacity: 0.3,
    shadowRadius: 4.65,
    elevation: 8,
  },
  counterText: {
    fontSize: 72,
    fontWeight: 'bold',
    color: '#2196F3',
  },
  counterTextDark: {
    color: '#2196F3',
  },
  buttonContainer: {
    width: '100%',
    gap: 15,
  },
  button: {
    padding: 18,
    borderRadius: 12,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  buttonIncrement: {
    backgroundColor: '#4CAF50',
  },
  buttonDecrement: {
    backgroundColor: '#f44336',
  },
  buttonReset: {
    backgroundColor: '#FF9800',
  },
  buttonText: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
  },
});

export default App;
