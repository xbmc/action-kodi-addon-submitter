# action-kodi-addon-submitter

![Kodi Logo](https://github.com/xbmc/xbmc/raw/master/docs/resources/banner_slim.png)

This action submits your addon to the official Kodi repository every time you push a tag. In the background it uses [romanvm's kodi-addon-submitter](https://github.com/romanvm/kodi-addon-submitter).

## Inputs

### `kodi-repository`

**Required** The name of the repository to where you want to submit the addon. Values can be ([repo-plugins](https://github.com/xbmc/repo-plugins) or [repo-scripts](https://github.com/xbmc/repo-scripts)). Defaults to `repo-plugins`.

### `kodi-version`

**Required** The name of the minimal kodi version your addon is supposed to support. Default `"leia"`.
This is equivalent to the **branch** name where your addon lives in the official kodi repository ([repo-plugins](https://github.com/xbmc/repo-plugins/branches) or [repo-scripts](https://github.com/xbmc/repo-scripts/branches)).

### `addon-id`

**Required** The id of your addon as defined in [addon.xml](https://kodi.wiki/view/Addon.xml).

### `kodi-matrix`

**Optional** Boolean indicating if a Python 2/3 compatible addon will be submitted to the `matrix` branch in addition to the target branch. This can be used if you want to update a Python 2/3 compatible addon both in `matrix` (Kodi 19.x) and a lower branch at the same time. Do not use this option if you want to submit a Python 3 addon only to `matrix` branch. Use the `kodi-repository` input for this.

## Secrets

### `GH_TOKEN`

**Required** A secret in your addon github repository that contains a github token with at least public_repo scope.

### `EMAIL`

**Required** A secret containing your email address. This is used in `git config` to submit the pull request.

## Outputs

### `addon-zip`

Path to the addon release zip file

### `addon-zip-matrix`

Path to the addon release zip file for matrix (if `kodi-matrix` input is `true`). This zip uses PEP440 local version identifier.

## Example usage

The below configuration will automatically submit your addon to the kodi repository when you create a new tag/release. For instance, supposing your addon update is version `1.0.1`:

`git tag v1.0.1 && git push --tags`

The configuration below assumes you are submitting an addon with id `plugin.video.example` to the branch `leia` of `repo-plugins`.

```yaml
name: Kodi Addon-Submitter

on:
  push:
    tags:
      - v*

jobs:
  kodi-addon-submitter:
    runs-on: ubuntu-latest
    name: Kodi addon submitter
    steps:
    - name: Checkout
      uses: actions/checkout@v1
    - name: Generate distribution zip and submit to official kodi repository
      id: kodi-addon-submitter
      uses: xbmc/action-kodi-addon-submitter@v1.1
      with: # Replace all the below variables
        kodi-repository: repo-plugins
        kodi-version: leia
        addon-id: plugin.video.example
        kodi-matrix: false # Submit a Python 2/3 compatible addon to matrix branch in addition to the target branch
      env: # Make sure you create the below secrets (GH_TOKEN and EMAIL)
        GH_USERNAME: ${{ github.actor }}
        GH_TOKEN: ${{secrets.GH_TOKEN}}
        EMAIL: ${{secrets.EMAIL}}
```

The configuration below automatically submits the addon to the same repository but also creates a github release and uploads the distribution zip to the github releases section of your github repository.


```yaml
name: Kodi Addon-Submitter

on:
  push:
    tags:
      - v*

jobs:
  kodi-addon-submitter:
    runs-on: ubuntu-latest
    name: Kodi addon submitter
    steps:
    - name: Checkout
      uses: actions/checkout@v1
    - name: Generate distribution zip and submit to official kodi repository
      id: kodi-addon-submitter
      uses: xbmc/action-kodi-addon-submitter@v1.1
      with: # Replace all the below values
        kodi-repository: repo-plugins
        kodi-version: leia
        addon-id: plugin.video.example
        kodi-matrix: false # Submit a Python 2/3 compatible addon to matrix branch in addition to the target branch
      env: # Make sure you create the below secrets (GH_TOKEN and EMAIL)
        GH_USERNAME: ${{ github.actor }}
        GH_TOKEN: ${{secrets.GH_TOKEN}}
        EMAIL: ${{secrets.EMAIL}}
    - name: Create Github Release
      id: create_release
      uses: actions/create-release@v1.0.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: ${{ github.ref }}
        release_name: Release ${{ github.ref }}
        draft: false
        prerelease: false
    - name: Upload Addon zip to github release
      id: upload-release-asset
      uses: actions/upload-release-asset@v1.0.1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        upload_url: ${{ steps.create_release.outputs.upload_url }}
        asset_path: ${{ steps.kodi-addon-submitter.outputs.addon-zip }}
        asset_name: ${{ steps.kodi-addon-submitter.outputs.addon-zip }}
        asset_content_type: application/zip

```

**Note:** The idea of generating a distribution zip is to automatically exclude some of your files from the submission (e.g. tests, .gitignore, .gitattributes, changelog.txt for upper versions of Kodi, etc). This can be accomplished if you store a `.gitattributes` file on the root of your repository containing the following:

```
.gitignore export-ignore
.gitattributes export-ignore
.github export-ignore
 changelog.txt export-ignore
```
