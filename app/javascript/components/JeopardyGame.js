import React from 'react'
import PropTypes from 'prop-types'

export default class JeopardyGame extends React.Component {
  static propTypes = {
    id: PropTypes.number.isRequired
  }

  constructor(props) {
    super(props)


    this.state = {
      id: this.props.id,
      categories: this.props.categories
    }
  }


  componentDidMount() {
    const pusher = new Pusher('12e21f086ab8bbad38d2', {
      cluster: 'us2',
      forceTLS: true
    })

    const channel = pusher.subscribe('jeopardy');
    channel.bind('update', (data) => {
      this._fetchGameData()
    })
  }

  _fetchGameData() {
    fetch(`/jeopardy_games/${this.props.id}.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'GET',
    }).then(response => response.json()).then(categories => {
      this.setState((prevState) => {
        return {
          categories: categories
        }
      })
    })
  }

  addCategory() {
    fetch(`/jeopardy_games/${this.props.id}/add_category.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'POST',
      body: JSON.stringify({
       name: 'category'
      })
    })
    // window.location.reload(false)
  }

  renderCategories() {
    return this.state.categories.map(category => {
      return (
        <div key='category' className='card category'>{category.name}</div>
      )
    })
  }

  render() {
    return (
      <div className='flex justify-center'>
        {this.renderCategories()}
        <button className='btn btn-outline-info' onClick={() => this.addCategory()}>Add Category</button>
      </div>
    )
  }
}
