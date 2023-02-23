import Stylesheet from 'reactjs-stylesheet'

const Header = ({name}) => {
    return (
        <div style={styles.container}>
            <h3>{name}</h3>
        </div>
    )
}

const styles = Stylesheet.create({
    container: {
        padding: 20
    }
})

export default Header