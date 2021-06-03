<template>
  <div id="app">
    <h2>Welcome to the temperature forecast</h2>

    <h4>Please enter your city and state</h4>
    <input v-model="city" placeholder="City">
    <input v-model="state" placeholder="State">
    <br />
    <br />
    <button v-on:click="getForecast">Get forecast</button>

    <p>
      Cache hit: {{ cacheHit }}
    </p>

    <h3>
      Forecast:
    </h3>

    <div>
      <b-table striped hover :items="forecast" :fields="forecastFields"></b-table>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      city: '',
      state: '',
      cacheHit: false,
      forecastFields: [ 'name', 'temperature', 'temperatureUnit', 'detailedForecast' ],
      forecast: [],
    }
  },
  methods: {
    async getForecast() {
      const params = new URLSearchParams();
      params.append('city', this.city);
      params.append('state', this.state);

      const forecast = await fetch(`/forecast?${params.toString()}`);
      const forecastJson = await forecast.json();

      this.cacheHit = forecastJson.cache_hit;
      if (Array.isArray(forecastJson.forecast)) {
        this.forecast = forecastJson.forecast;
      }
    }
  }
}
</script>

<style scoped>

</style>
