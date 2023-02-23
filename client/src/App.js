import { useState } from 'react';
import './App.css';
import ContactList from './components/ContactList';
import Header from './components/Header';
import MessageInfo from './components/MessageInfo';

function App() {

  const [message, setMessage] = useState('')
  const [number, setNumber] = useState('')
  const [numberList, setNumberList] = useState([])

  return (
    <div className="App">
      <Header name='Lasagna' />
      <MessageInfo 
          message={{message, setMessage}}
          number={{number, setNumber}}
          numberList={{numberList, setNumberList}}
      />
      <ContactList 
        numbers={numberList}
        setNumbers={setNumberList}
      />
    </div>
  );
}

export default App;
