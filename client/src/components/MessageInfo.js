import variables from '../variables'
import { useRef } from 'react'
import Stylesheet from 'reactjs-stylesheet'

const MessageInfo = ({message, number, numberList}) => {
    const tempNum = useRef('')
    const numberRef = useRef(null)

    function add(e) {
        e.preventDefault()
        tempNum.current = numberRef.current.value
        numberList.setNumberList(numbers => {
            if (numbers && numbers.includes(tempNum.current)) {
                // alert
                return numbers
            }
            number.setNumber('')
            return [...numbers, tempNum.current]
        })
        numberRef.current.focus()
    }

    async function send() {
        const server_url = variables.SERVER_URL
        try {
            console.log(server_url);
            const response = await fetch(`${server_url}/sendMessage`, {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    message: message.message,
                    numbers: numberList.numberList
                })
            })
            const success = await response.json()
            console.log(success);
        } catch (error) {
            console.error(error.message);
        }
        numberRef.current.focus()
    }

    return (
        <div style={styles.container}>
            <textarea 
                autoFocus
                style={styles.message}
                placeholder='Enter your message...'
                value={message.message}
                onChange={(e) => message.setMessage(e.target.value)}
            />
            <form onSubmit={add} style={styles.form}>
                <input 
                    style={styles.number}
                    placeholder='Enter recepient number (+...)'
                    value={number.number}
                    onChange={(e) => number.setNumber(e.target.value)}
                    type='tel'
                    ref={numberRef}
                />
                <button type='submit' onClick={add} 
                    style={styles.addButton}>ADD</button>
            </form>
            <button onClick={send} 
                style={styles.sendButton}>SEND</button>
        </div>
    )
}

const styles = Stylesheet.create({
    container: {
        display: 'flex',
        flexFlow: 'column',
        alignContent: 'center',
        gap: 20,
    },
    message: {
        width: 400,
        maxWidth: '90%',
        alignSelf: 'center',
        height: 200,
        resize: 'none',
        padding: 10,
        borderRadius: 10,
        borderWidth: 1,
        outline: 'none',
    },
    number: {
        borderRadius: 10,
        textIndent: 10,
        height: 30,
        outline: 'none',
        borderWidth: 1,
        flex: 1
    },
    addButton: {
        border: 'none',
        height: 30,
        width: 100,
        borderRadius: 10,
        backgroundColor: '#121212',
        color: 'white'
    },
    sendButton: {
        width: 400,
        maxWidth: '90%',
        alignSelf: 'center',
        height: 40,
        borderRadius: 10,
        outline: 'none',
        border: 'none',
        backgroundColor: '#121212',
        color: 'white'
    },
    form: {
        display: 'flex',
        maxWidth: '90%',
        gap: 10,
        width: 400,
        alignSelf: 'center'
    }
})

export default MessageInfo