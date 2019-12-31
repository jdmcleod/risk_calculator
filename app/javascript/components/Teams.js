import React from 'react'
import PropTypes from 'prop-types'

export default class Teams extends React.Component {
  static propTypes = {
    teams: PropTypes.array.isRequired,
    removeTeam: PropTypes.func.isRequired
  }

  renderTeams() {
    return this.props.teams.map(team => {
      return (
        <div key={team.name}>
          <h5 className='text-align-center'>{team.name}</h5>
          <h5 className='text-align-center'>{team.score}</h5>
          <button className='btn remove-player' onClick={() => this.props.removeTeam(team.id)}>remove</button>
        </div>
      )
    })
  }

  render() {
    return (
      <div>
        <div className='teams-container'>
          {this.renderTeams()}
        </div>
      </div>
    )
  }
}
