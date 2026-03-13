# User Preferences

## Code Formatting

When formatting code to stay under 80 characters, use a compact style:
- Only move parameters to the next line when necessary to keep lines under 80 chars
- Multiple parameters can share a line if they fit
- Type and name of a parameter should always be on the same line

Example - prefer this compact style:
```csharp
return await client.GetDataAsync(request, acceptHeader,
    cancellationToken).ConfigureAwait(false);
```

Over this unnecessarily spread out style:
```csharp
return await client.GetDataAsync(
    request, acceptHeader, cancellationToken).ConfigureAwait(false);
```
