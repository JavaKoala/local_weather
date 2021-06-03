<template>
  <div id="app">
    <h2>Welcome to the temperature forecast</h2>

    <h4>Please enter your city and state</h4>
    <ValidationObserver v-slot="{ invalid }">
      <form @submit.prevent="getForecast">
        <ValidationProvider name="City" rules="required" v-slot="{ errors }">
          <input v-model="city" type="text">
          <span>{{ errors[0] }}</span>
        </ValidationProvider>

        <ValidationProvider name="State" rules="required" v-slot="{ errors }">
          <input v-model="state" type="text">
          <span>{{ errors[0] }}</span>
        </ValidationProvider>

        <button type="submit" :disabled="invalid">Get forecast</button>
      </form>
    </ValidationObserver>

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
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import { extend } from 'vee-validate';
import { required } from 'vee-validate/dist/rules';

extend('required', required);

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
  },
  components: {
    ValidationObserver,
    ValidationProvider
  }
}
</script>

<style scoped>

</style>
