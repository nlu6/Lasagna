import { useRef } from 'react'
import Stylesheet from 'reactjs-stylesheet'

const Contact = ({ number, setNumbers }) => {

    const numberRef = useRef(null)

    function deleteNumber() {
        setNumbers(numbers => {
            return numbers.filter(x => x !== numberRef.current.innerText)
        })
    }

    return (
        <div style={styles.container}>
            <p ref={numberRef} >{number}</p>
            <i onClick={deleteNumber}>#</i>
        </div>
    )
}

const styles = Stylesheet.create({
    container: {
        width: 400,
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: 10,
        paddingLeft: 20,
        paddingRight: 20,
        backgroundColor: '#127f99',
        color: 'white',
        maxWidth: '100%',
        borderRadius: 10
    }
})

export default Contact