import { shallowMount } from '@vue/test-utils'
import App from '@/../app/javascript/App.vue'

describe('app.vue', () => {
  it('renders app', () => {
    const wrapper = shallowMount(App);
    expect(wrapper.text()).toMatch('Welcome to the temperature forecast');
  });

  describe('getForecast', () => {
    it('updates forcast and cacheHit', async () => {
      global.fetch = jest.fn(() =>
        Promise.resolve({
          json: () => Promise.resolve({ cache_hit: true, forecast: ['test-forecast'] }),
        })
      );

      const wrapper = shallowMount(App);
      await wrapper.vm.getForecast();

      expect(wrapper.vm.cacheHit).toEqual(true);
      expect(wrapper.vm.foundCity).toEqual(true);
      expect(wrapper.vm.forecast).toEqual(['test-forecast']);
      expect(wrapper.vm.loading).toEqual(false);
    });

    it('does not update forcast when it is not an array', async () => {
      global.fetch = jest.fn(() =>
        Promise.resolve({
          json: () => Promise.resolve({ cache_hit: false, forecast: 'test' }),
        })
      );

      const wrapper = shallowMount(App);
      wrapper.vm.forecast = ['warm and sunny'];
      await wrapper.vm.getForecast();

      expect(wrapper.vm.foundCity).toEqual(false);
      expect(wrapper.vm.forecast).toEqual([]);
      expect(wrapper.vm.loading).toEqual(false);
    });
  });
});
