This is what is currently available in the `nightly` docker build.

**Alternate endpoint:**
To configure Firefly like you want you need to use the alternate entry point.

- Instructions are in the docker hub, scroll to the bottom. https://hub.docker.com/r/ipac/firefly
- Basically you load firefly with an alternate html path
   http://localhost/local/ instead of http://localhost/firefly/

- You can configure the image panel in the HTML file.

- When you map a directory (per the instructions) the first time, and the directory is empty,
   it will place example HTML files in there. You want to look at `firefly-dev.html`, take
   the config examples, and put them in the `index.html` and reload.

**Image Panel config:** 
In `firefly-dev.html` and `index.html` you will see this big firefly config object. 

- It allows for an array in `firefly.options.imageMasterAdditionalSources`
- In `firefly-dev.html` this array is created in `getMoreImagePanelDataTest()`. You can modify the function or just set the array of objects directly.
- Modify this array to your needs.  All data defined will go on the top of the panel.
- The key is setting up the URL correctly. Firefly will do token substitution with the following keys before it calls the service
	- Token substitution keys: `ra,dec,size, sizeDeg, sizeArcMin, sizeArcSec` - e.g. `${ra}`
	- Part of the DSS URL looks like this: `r=${ra}&d=${dec}&e=J2000&h=${sizeArcMin}&w=${sizeArcMin}&f=FITS&v=poss2ukstu_ir&s=ON&c=gz`
You can also see this in the examples.
	- There are 4 or 5 examples in the `firefly-dev.html`, calling DSS images, IRSA table, and a TAP obscore table.
	- Make sure you set dataType to ‘image' or ‘table'. This determines how the url is is called and what to expect for the return. 'image' returns a fits, 'table' returns a table.
	- If you have a  non-ObsCore table that has a columns with image URLs make sure you set that as well. look at around line 142 of `firefly-dev.html`, see datasource. It should have the column name that has the fits file URLs.
	- The example TAP call is to a sync service, this is one way to test out your TAP stuff until you get the async in place.
	- The token substitution is very similar to the type of stuff you see in VO standards.


**Adding more TAP services**
- `firefly.options.tap.additional.services`
- The above are object paths.  Sorry it is so deep.
- An array of objects that look like this:
	- [{ label: 'IRSA https://irsa.ipac.caltech.edu/TAP',    value: 'https://irsa.ipac.caltech.edu/TAP’ }]
- In the html file under options should/would have a entry like:
	- tap: {additional: {services: [{ label: 'IRSA https://irsa.ipac.caltech.edu/TAP', value: 'https://irsa.ipac.caltech.edu/TAP’ }]}}

I think this covers your basic needs. Turns out that there were just some simple changes in
the code and docker container that needed to be made to support your request. Like I said,
this is only in the nightly right now. We are putting out our next release sometime after
ADASS in mid October, release-2019.3.0.
