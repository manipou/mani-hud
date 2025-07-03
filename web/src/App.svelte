<script lang="ts">
	import Dashboard from "$lib/Dashboard.svelte";
	import VisibilityProvider from "$lib/providers/VisibilityProvider.svelte";
</script>

<VisibilityProvider>
	<Dashboard />
</VisibilityProvider>
