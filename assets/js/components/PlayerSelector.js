import React from 'react';
import Select from 'react-select';
import 'whatwg-fetch';
import stripDiacritics from '../utils/stripDiacritics';

class PlayerSelector extends React.Component {

  filterOptions (options, filterValue, excludeOptions, props) {
		filterValue = stripDiacritics(filterValue);
		filterValue = filterValue.toLowerCase();
    if (filterValue == "") {
      return [];
    }
    if (excludeOptions) excludeOptions = excludeOptions.map(i => i[props.valueKey]);

  	return options.filter(option => {
  		if (excludeOptions && excludeOptions.indexOf(option[props.valueKey]) > -1) return false;
  		if (props.filterOption) return props.filterOption.call(this, option, filterValue);
  		if (!filterValue) return true;
  		var valueTest = String(option[props.valueKey]);
  		var labelTest = String(option[props.labelKey]);
  		if (props.ignoreAccents) {
  			if (props.matchProp !== 'label') valueTest = stripDiacritics(valueTest);
  			if (props.matchProp !== 'value') labelTest = stripDiacritics(labelTest);
  		}
  		if (props.ignoreCase) {
  			if (props.matchProp !== 'label') valueTest = valueTest.toLowerCase();
  			if (props.matchProp !== 'value') labelTest = labelTest.toLowerCase();
  		}
  		return props.matchPos === 'start' ? (
  			(props.matchProp !== 'label' && valueTest.substr(0, filterValue.length) === filterValue) ||
  			(props.matchProp !== 'value' && labelTest.substr(0, filterValue.length) === filterValue)
  		) : (
  			(props.matchProp !== 'label' && valueTest.indexOf(filterValue) >= 0) ||
  			(props.matchProp !== 'value' && labelTest.indexOf(filterValue) >= 0)
  		);
  	});
  }

  loadOptions() {
    return fetch('http://' + document.location.host + '/players')
    .then(res => {
      return res.json().then(data => {
        const players = data.players.map(player => ({value: player.id, label: player.name}));
        this.setState({options: players});
      });
    });
  }

  loadPlayers() {
    return fetch(document.location.href.replace(/\/$/, "") + '/players')
    .then(res => {
      return res.json().then(data => {
        const players = data.players.map(player => ({value: player.id, label: player.name}));
        this.setState({value: players});
      });
    });
  }

  constructor(props){
    super(props);
    this.state = {
      value: [],
      options: []
    }
  }

  componentWillMount() {
    this.loadOptions().then(() => {
      if (document.location.pathname != "/"){
        this.loadPlayers();
      }
    });
  }


  render(){
    return <Select
      multi={true}
      value={this.state.value}
      options={this.state.options}
      name="subscription[players][]"
      placeholder="Favourite players ..."
      filterOptions={this.filterOptions}
      onChange={(value) => this.setState({value})}
    />;
  }
}

export default PlayerSelector;
