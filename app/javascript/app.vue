<template>
  <div id="app">
    <h2>Welcome to the temperature forecast</h2>

    <input v-model="city" placeholder="City">
    <input v-model="state" placeholder="State">
    <br />
    <br />
    <button v-on:click="getForecast">Get forecast</button>

    <p>
      {{ cacheHit }}
    </p>
    <p>
      {{ forecast }}
    </p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      city: '',
      state: '',
      cacheHit: false,
      forecast: [],
    }
  },
  methods: {
    async getForecast() {
      console.log(this.city + ' ' + this.state);

      const params = new URLSearchParams();
      params.append('city', this.city);
      params.append('state', this.state);

      const forecast = await fetch(`/forecast?${params.toString()}`);
      const forecastJson = await forecast.json();

      this.cacheHit = forecastJson.cache_hit
      this.forecast = forecastJson.forecast
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
