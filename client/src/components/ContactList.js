import Stylesheet from 'reactjs-stylesheet'
import Contact from './Contact'

const ContactList = ({ numbers, setNumbers }) => {

    const numbersDOM = numbers.map((number) => {
        return <Contact key={number} number={number} setNumbers={setNumbers} />
    })

    return (
        <div style={styles.container}>
            {numbersDOM}
        </div>
    )

}

const styles = Stylesheet.create({
    container: {
        display: 'flex',
        alignItems: 'center',
        flexFlow: 'column',
        gap: 10,
        margin: 20,
        height: 300,
        overflow: 'scroll'
    }
})

export default ContactList