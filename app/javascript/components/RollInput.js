import React from 'react'
import PropTypes from 'prop-types'

export default class RollInput extends React.Component {
  static propTypes = {
    players: PropTypes.array.isRequired,
    id: PropTypes.number.isRequired
  }

  constructor(props) {
    super(props)

    this.state = {
      players: this.props.players,
      id: this.props.id,
    }
  }

  // Handlers

  handlePlayerSelected(cssId) {
    fetch(`/calculators/${this.state.id}.json`, {
      headers: { 'Content-Type': 'application/json' },
      method: 'PATCH',
      body: JSON.stringify({ attacker: this.state.attacker, defender: this.state.defender,
                             numberWins: this.state.numberWins })
    })
  }

  _renderPlayers() {
    return this.state.players.map(player => {
      return (
        <button className='btn btn-outline-success m-2'>{player.name}</button>
      )
    })
  }

  render() {
    return (
      <div className='contents'>
        { this._renderPlayers() }
      </div>
    )
  }
}

