<template>
  <div id="app">
    <div class="search-container">
      <div class="jumbotron">
        <h1>Welcome to the temperature forecast</h1>
        <h4>Please enter your city and state</h4>
      </div>

      <ValidationObserver v-slot="{ invalid }">
        <form @submit.prevent="getForecast" class="forecast-form">
          <div class="form-group">
            <ValidationProvider name="City" rules="required" v-slot="{ errors }">
              <label for="city" class="city-state-input">City</label>
              <input v-model="city" type="text">
              <span class="error-label">{{ errors[0] }}</span>
            </ValidationProvider>
          </div>

          <div class="form-group">
            <ValidationProvider name="State" rules="required" v-slot="{ errors }">
              <label for="state" class="city-state-input">State</label>
              <input v-model="state" type="text">
              <span class="error-label">{{ errors[0] }}</span>
            </ValidationProvider>
          </div>

          <button type="submit" class="btn btn-primary btn-lg" :disabled="invalid">Get forecast</button>
        </form>
      </ValidationObserver>

      <p>
        Cache hit: {{ cacheHit }}
      </p>

    </div>

    <div class="forcast-container">
      <h3>
        Forecast:
      </h3>

      <div>
        <b-table striped hover :items="forecast" :fields="forecastFields"></b-table>
      </div>
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
      this.forecast = [];

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

