package gnominers

import (
	"std"
	"time"

	"gno.land/p/pol/notrandom"
	"gno.land/p/pol/queryparsing"
	"gno.land/r/leon/hor"
	// "gno.land/r/pol/gnominers"
	// "gno.land/r/pol/home"
)

var randomMachine *notrandom.Machine

var (
	gnominersPath         = std.CurrentRealm().PkgPath()[len(std.ChainDomain()):]
	gnominersShopPath     = gnominersPath + ":shop"
	gnominersDashboard    = gnominersPath + ":dashboard"
	gnominersAchievements = gnominersPath + ":achievements"
	gnominersDAO          = gnominersPath + ":dao"
	gnominersDAORequest   = gnominersPath + ":daoreq"
)

var redirectionsPath = map[string]func(params map[string]string) string{
	"shop":         renderShop,
	"dashboard":    renderDashboard,
	"achievements": renderAchievements,
	"dao":          renderDao,
	"daoreq":       renderDaoRequestGenerator,
}

// the rendering

func init() {
	randomMachine = notrandom.NewMachine(time.Now().Unix())
	hor.Register("GnoMiners", "A super mining game !")
}

func Render(fullpath string) string {
	path, params := queryparsing.Parse(fullpath)
	if redirect, ok := redirectionsPath[path]; ok {
		return redirect(params)
	}
	return renderUserPage(params)
}
